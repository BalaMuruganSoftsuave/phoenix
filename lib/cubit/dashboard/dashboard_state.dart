import 'package:phoenix/helper/enum_helper.dart';
import 'package:phoenix/models/filter_payload_model.dart';
import 'package:phoenix/models/permission_model.dart';

class DashboardState {
  FilterPayload? filterPayload;
  PermissionResponse? permissions;
  ProcessState? permissionReqState;

  DashboardState(
      {this.filterPayload,
      this.permissions,
      this.permissionReqState = ProcessState.none});

  DashboardState copyWith({
    FilterPayload? filterPayload,
    PermissionResponse? permissions,
    ProcessState? permissionReqState,
  }) {
    return DashboardState(
        filterPayload: filterPayload ?? this.filterPayload,
        permissions: permissions ?? this.permissions,
        permissionReqState: permissionReqState ?? this.permissionReqState);
  }
}
