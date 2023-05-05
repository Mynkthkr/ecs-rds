module "db" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-rds.git"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.m5.xlarge"
  allocated_storage = 5

  db_name  = local.workspace["rds"]["db_name"]
  username = local.workspace["rds"]["username"]
  port     = local.workspace["rds"]["port"]

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-02a3730f5ad90acdb"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = ["subnet-0107c7a2008e5c86c", "subnet-083eff7405740f87c", "subnet-097b7240437bd0849"]

  # DB parameter group
  family = local.workspace["rds"]["family"]
  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}