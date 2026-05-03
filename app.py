# ============================================================
# Blood Bank Management System
# Streamlit Frontend
# ============================================================

import streamlit as st
import pandas as pd
from donors import get_all_donors, add_donor, search_donor
from blood_units import get_available_stock, get_expired_units, check_availability
from blood_requests import get_pending_requests, get_all_requests, approve_request
from reports import (get_donor_summary, get_units_by_blood_group,
                     get_monthly_report, get_discard_report,
                     get_requests_by_status)

# ── Page config ──────────────────────────────────────────
st.set_page_config(
    page_title="Blood Bank Management System",
    page_icon="🩸",
    layout="wide"
)

st.title("Blood Bank Management System")
st.markdown("---")

# ── Sidebar navigation ───────────────────────────────────
page = st.sidebar.selectbox("Navigate", [
    "Dashboard",
    "Donors",
    "Blood Units",
    "Blood Requests",
    "Reports"
])

# ════════════════════════════════════════════════════════
# DASHBOARD
# ════════════════════════════════════════════════════════
if page == "Dashboard":
    st.header("Dashboard")

    col1, col2, col3, col4 = st.columns(4)

    donors_df  = get_all_donors()
    stock_df   = get_available_stock()
    pending_df = get_pending_requests()
    expired_df = get_expired_units()

    col1.metric("Total Donors",          len(donors_df))
    col2.metric("Available Blood Units", len(stock_df))
    col3.metric("Pending Requests",      len(pending_df))
    col4.metric("Expired Units",         len(expired_df))

    st.markdown("---")

    col5, col6 = st.columns(2)

    with col5:
        st.subheader("Blood Units by Blood Group")
        bg_df = get_units_by_blood_group()
        st.bar_chart(bg_df.set_index("bloodGroup"))

    with col6:
        st.subheader("Requests by Status")
        status_df = get_requests_by_status()
        st.bar_chart(status_df.set_index("status"))

# ════════════════════════════════════════════════════════
# DONORS
# ════════════════════════════════════════════════════════
elif page == "Donors":
    st.header("Donor Management")

    tab1, tab2, tab3 = st.tabs(["View All", "Add Donor", "Search by Blood Group"])

    with tab1:
        st.subheader("All Donors")
        st.dataframe(get_all_donors(), use_container_width=True)

    with tab2:
        st.subheader("Add New Donor")
        col1, col2 = st.columns(2)
        with col1:
            name        = st.text_input("Full Name")
            gender      = st.selectbox("Gender", ["Male", "Female", "Other"])
            age         = st.number_input("Age", min_value=18, max_value=65, value=25)
        with col2:
            contact     = st.text_input("Contact Number")
            blood_group = st.selectbox("Blood Group",
                          ["A+","A-","B+","B-","AB+","AB-","O+","O-"])

        if st.button("Add Donor", type="primary"):
            if name and contact:
                success, msg = add_donor(name, gender, age, contact, blood_group)
                if success:
                    st.success(msg)
                else:
                    st.error(f"Error: {msg}")
            else:
                st.warning("Please fill in all fields!")

    with tab3:
        st.subheader("Search Donors by Blood Group")
        bg = st.selectbox("Select Blood Group",
                          ["A+","A-","B+","B-","AB+","AB-","O+","O-"],
                          key="search_bg")
        if st.button("Search"):
            result = search_donor(bg)
            if not result.empty:
                st.dataframe(result, use_container_width=True)
            else:
                st.info("No donors found for this blood group.")

# ════════════════════════════════════════════════════════
# BLOOD UNITS
# ════════════════════════════════════════════════════════
elif page == "Blood Units":
    st.header("Blood Unit Management")

    tab1, tab2, tab3 = st.tabs(["Available Stock", "Expired Units", "Check Availability"])

    with tab1:
        st.subheader("Available Blood Stock")
        st.dataframe(get_available_stock(), use_container_width=True)

    with tab2:
        st.subheader("Expired Blood Units")
        expired = get_expired_units()
        if not expired.empty:
            st.dataframe(expired, use_container_width=True)
        else:
            st.success("No expired units found!")

    with tab3:
        st.subheader("Check Availability by Blood Group")
        bg = st.selectbox("Select Blood Group",
                          ["A+","A-","B+","B-","AB+","AB-","O+","O-"],
                          key="avail_bg")
        if st.button("Check"):
            result = check_availability(bg)
            if not result.empty:
                st.success(f"{len(result)} unit(s) available for {bg}")
                st.dataframe(result, use_container_width=True)
            else:
                st.warning(f"No units available for {bg}")

# ════════════════════════════════════════════════════════
# BLOOD REQUESTS
# ════════════════════════════════════════════════════════
elif page == "Blood Requests":
    st.header("Blood Request Management")

    tab1, tab2 = st.tabs(["All Requests", "Pending Requests"])

    with tab1:
        st.subheader("All Blood Requests")
        st.dataframe(get_all_requests(), use_container_width=True)

    with tab2:
        st.subheader("Pending Requests")
        pending = get_pending_requests()
        if not pending.empty:
            st.dataframe(pending, use_container_width=True)
            st.markdown("---")
            st.subheader("Approve a Request")
            request_id = st.number_input("Enter Request ID to Approve",
                                          min_value=1, step=1)
            if st.button("Approve", type="primary"):
                success, msg = approve_request(request_id)
                if success:
                    st.success(msg)
                    st.rerun()
                else:
                    st.error(f"Error: {msg}")
        else:
            st.success("No pending requests!")

# ════════════════════════════════════════════════════════
# REPORTS
# ════════════════════════════════════════════════════════
elif page == "Reports":
    st.header("Reports and Analytics")

    tab1, tab2, tab3 = st.tabs(["Donor Summary", "Monthly Report", "Discard Report"])

    with tab1:
        st.subheader("Donor Summary")
        st.dataframe(get_donor_summary(), use_container_width=True)

    with tab2:
        st.subheader("Monthly Donation Report")
        col1, col2 = st.columns(2)
        with col1:
            year  = st.selectbox("Year",  [2024, 2025, 2026])
        with col2:
            month = st.selectbox("Month", list(range(1, 13)))
        if st.button("Generate Report"):
            result = get_monthly_report(year, month)
            if not result.empty:
                st.dataframe(result, use_container_width=True)
            else:
                st.info("No donations found for this period.")

    with tab3:
        st.subheader("Discard Report")
        st.dataframe(get_discard_report(), use_container_width=True)