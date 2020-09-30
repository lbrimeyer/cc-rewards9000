resource "aws_dynamodb_table" "ddb_source" {
  name         = var.app_name
  billing_mode = var.ddb_billing_mode
  hash_key     = var.ddb_partition_key_name

  attribute {
    name = var.ddb_partition_key_name
    type = var.ddb_partition_key_type
  }

  tags = {
    Name = "${var.app_name}-data-store"
    Project = var.app_name
  }

  lifecycle {
      ignore_changes = [read_capacity, write_capacity]
  }
}
