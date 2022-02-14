terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
       version = "1.15.0"
    }
  }
}

provider "postgresql" {
  host            = "127.0.0.1"
  port            = 5432
  database        = "postgres"
  username        = "postgres"
  password        = ""
  sslmode         = "disable"
  connect_timeout = 15
}

resource "postgresql_role" "employeeuser" {
  name     = "employeeuser"
  login    = true
  password = "mypass"
}
resource "postgresql_role" "partneruser" {
  name     = "partneruser"
  login    = true
  password = "mypass"
}
resource "postgresql_role" "readonlyUser" {
  name     = "readonlyuser"
  login    = true
  password = "mypass"
}


resource "postgresql_grant" "employeeconnectgrant" {
  database    = "${postgresql_database.employeedb.name}"
  role        = "${postgresql_role.employeeuser.name}"
  schema      = "public"
  object_type = "database"
  #objects     = ["table1", "table2"]
  privileges  = ["CONNECT"]
}
resource "postgresql_grant" "employeegrant" {
  database    = "${postgresql_database.employeedb.name}"
  role        = "${postgresql_role.employeeuser.name}"
  schema      = "public"
  object_type = "table"
  #objects     = ["table1", "table2"]
  privileges  = ["SELECT","INSERT","DELETE","UPDATE"]
}
resource "postgresql_default_privileges" "employeeDefaultGrant" {
   database    = "${postgresql_database.employeedb.name}"
  role        = "${postgresql_role.employeeuser.name}"
  schema   = "public"

  owner       =  "postgres"
  object_type = "table"
  privileges  = ["SELECT","INSERT","DELETE","UPDATE"]
}


resource "postgresql_grant" "employeereadonlyUsergrant" {
  database    = "${postgresql_database.employeedb.name}"
  role        = "${postgresql_role.readonlyUser.name}"
  schema      = "public"
  object_type = "table"
  #objects     = ["table1", "table2"]
  privileges  = ["SELECT"]
}
resource "postgresql_default_privileges" "employeereadonlyUserDefaultGrant" {
   database    = "${postgresql_database.employeedb.name}"
  role        = "${postgresql_role.readonlyUser.name}"
  schema   = "public"
  owner       =  "postgres"
  object_type = "table"
  privileges  = ["SELECT"]
}

# resource "postgresql_grant" "revoke_public" {
#   database    = "${postgresql_database.my_db.name}"
#   role        = "public"
#   schema      = "public"
#   object_type = "schema"
#   privileges  = []
# }

resource "postgresql_database" "employeedb" {
  name              = "employee"
  owner             = "${postgresql_role.employeeuser.name}"
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}

# resource "postgresql_schema" "writer" {
#   name  = "writer"
#   owner = "postgres"

#   policy {
#     usage = true
#     role  = "${postgresql_role.role1.name}"
#   }
# }

# resource "postgresql_role" "app_www" {
#   name = "app_www"
# }

# resource "postgresql_role" "app_dba" {
#   name = "app_dba"
# }

# resource "postgresql_role" "app_releng" {
#   name = "app_releng"
# }
# resource "postgresql_schema" "my_schema" {
#   name  = "my_schema"
#   owner = "postgres"

#   policy {
#     usage = true
#     role  = "${postgresql_role.app_www.name}"
#   }

#   # app_releng can create new objects in the schema.  This is the role that
#   # migrations are executed as.
#   policy {
#     create = true
#     usage  = true
#     role   = "${postgresql_role.app_releng.name}"
#   }

#   policy {
#     create_with_grant = true
#     usage_with_grant  = true
#     role              = "${postgresql_role.app_dba.name}"
#   }
# }


