import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constant {
  static const production = "https://hrcemtac.in/";
  static const MAIN_URL = production;

  static const API_URL = MAIN_URL + "api";
  static const PRIVACY_POLICY_URL = MAIN_URL + "privacy";

  static const LOGIN_URL = "$API_URL/login";
  static const LOGOUT_URL = "$API_URL/logout";
  static const DASHBOARD_URL = "$API_URL/dashboard";
  static const CHECK_IN_URL = "$API_URL/employees/check-in";
  static const CHECK_OUT_URL = "$API_URL/employees/check-out";
  static const ATTENDANCE_REPORT_URL = "$API_URL/employees/attendance-detail";
  static const LEAVE_TYPE_URL = "$API_URL/leave-types";
  static const LEAVE_TYPE_DETAIL_URL = "$API_URL/leave-requests/employee-leave-requests";
  static const ISSUE_LEAVE = "$API_URL/leave-requests/store";
  static const CANCEL_LEAVE = "$API_URL/leave-requests/cancel";
  static const DELETE_LEAVE_URL = "$API_URL/leave-requests/delete";
  static const LEAVE_FOR_CONFIRMATION_URL = "$API_URL/leave-requests/for-confirmation";
  static const LEAVE_CONFIRM_URL = "$API_URL/leave-requests"; // /{id}/confirm
  static const PROFILE_URL = "$API_URL/users/profile";
  static const EMPLOYEE_PROFILE_URL = "$API_URL/users/profile-detail";
  static const CONTENT_URL = "$API_URL/static-page-content";
  static const TEAM_SHEET_URL = "$API_URL/users/company/team-sheet";
  static const LEAVE_CALENDAR_API =
      "$API_URL/leave-requests/employee-leave-calendar";
  static const LEAVE_CALENDAR_BY_DAY_API =
      "$API_URL/leave-requests/employee-leave-list";
  static const HOLIDAYS_API = "$API_URL/holidays";
  static const CHANGE_PASSWORD_API = "$API_URL/users/change-password";
  static const RULES_API = "$API_URL/company-rules";
  static const EDIT_PROFILE_URL = "$API_URL/users/update-profile";
  static const NOTIFICATION_URL = "$API_URL/notifications";
  static const NOTICE_URL = "$API_URL/notices";
  static const MEETING_URL = "$API_URL/team-meetings";
  static const GATE_PASSES_URL = "$API_URL/gate-passes";
  static const SHIFT_HANDOVER_EMPLOYEES_URL = "$API_URL/shift-handovers/employees";
  static const SHIFT_HANDOVER_URL = "$API_URL/shift-handovers";
  static const OVERTIME_URL = "$API_URL/overtime";
  static const OVERTIME_REQUEST_URL = "$API_URL/overtime/request";
  static const OVERTIME_FOR_APPROVAL_URL = "$API_URL/overtime/for-approval";
  static const SUBSTITUTION_EMPLOYEES_URL = "$API_URL/substitutions/employees";
  static const SUBSTITUTION_URL = "$API_URL/substitutions";
  static const SUBSTITUTION_FOR_APPROVAL_URL = "$API_URL/substitutions/for-approval";
  static const OPERATIONS_DAILY_ENTRIES_URL = "$API_URL/operations/daily-entries";
  static const OPERATIONS_ASSIGNED_UNITS_URL = "$API_URL/operations/assigned-units";

  static const PROJECT_DASHBOARD_URL = "$API_URL/project-management-dashboard";
  static const PROJECT_LIST_URL = "$API_URL/assigned-projects-list";
  static const PROJECT_DETAIL_URL = "$API_URL/assigned-projects-detail";
  static const TASK_LIST_URL = "$API_URL/assigned-task-list";
  static const TASK_DETAIL_URL = "$API_URL/assigned-task-detail";
  static const UPDATE_CHECKLIST_TOGGLE_URL =
      "$API_URL/assigned-task-checklist/toggle-status";
  static const UPDATE_TASK_TOGGLE_URL =
      "$API_URL/assigned-task-detail/change-status";
  static const EMPLOYEE_DETAIL_URL = "$API_URL/users/profile-detail";
  static const GET_COMMENT_URL = "$API_URL/assigned-task-comments";
  static const SAVE_COMMENT_URL = "$API_URL/assigned-task/comments/store";
  static const DELETE_COMMENT_URL = "$API_URL/assigned-task/comment/delete";
  static const DELETE_REPLY_URL = "$API_URL/assigned-task/reply/delete";

  static const TADA_LIST_URL = "$API_URL/employee/tada-lists";
  static const TADA_DETAIL_URL = "$API_URL/employee/tada-details";
  static const TADA_STORE_URL = "$API_URL/employee/tada/store";
  static const TADA_UPDATE_URL = "$API_URL/employee/tada/update";
  static const TADA_DELETE_ATTACHMENT_URL = "$API_URL/employee/tada/delete-attachment";

  static const SUPPORT_URL = "$API_URL/support/query-store";
  static const DEPARTMENT_LIST_URL = "$API_URL/support/department-lists";
  static const SUPPORT_LIST_URL = "$API_URL/support/get-user-query-lists";

  static const INTERNAL_REQUISITIONS_FOR_APPROVAL = "$API_URL/internal-requisitions/for-approval";
  static const INTERNAL_REQUISITIONS_APPROVE = "$API_URL/internal-requisitions"; // /{id}/approve
  static const INTERNAL_REQUISITIONS_REJECT = "$API_URL/internal-requisitions"; // /{id}/reject
  static const INTERNAL_REQUISITIONS_DETAIL_URL = "$API_URL/internal-requisitions/for-approval"; // /{id}
  static const INTERNAL_REQUISITIONS_APPROVE_ALL_URL = "$API_URL/internal-requisitions"; // /{id}/approve
  
  static const SHIFT_ROSTER_URL = "$API_URL/employees/shift-roster";

  static const TOTAL_WORKING_HOUR = 8;
}

extension StringExtension on String {
  bool isUnique() {
    return true;
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 12);
}
