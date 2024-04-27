// ignore_for_file: constant_identifier_names

enum ScreenOrientation { Portrait, Landscape }

//* ENTITY *//

enum EntityStatus { Loading, Idle, Completed }

enum EntityType {
  Dashboard,
  User,
  Client,
  Project,
  Finance,
  Workflow,
  System,
  Default
}

enum EntityOperation { Create, Read, Update, Delete }

//* WORKFLOW *//

enum WorkflowType { Step, Substep }

//* FINANCE *//

enum FinanceOperationType { Initial, Parcel, Positive, Negative }
