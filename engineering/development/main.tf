locals {
  datasets = [
    module.bq_data_set
  ]
  datasets_map = { for dataset in local.datasets: dataset.bigquery_dataset.dataset_id => dataset.bigquery_dataset }


/*************************************
 Project id's
**************************************/


data "google_project" "test_bq_prj" {
  project_id = "xxx-xx-xx-125vgd"
}

/*************************************
Dataset creation
**************************************/

module "test_bq_data_set" {
  source               = "terraform-google-modules/bigquery/google"
  version              = "~> 5.4.2"
  dataset_id           = "test_dataset_id"
  dataset_name         = "test_dataset"
  description          = "A test data set contains users data"
  project_id           = data.google_project.test_bq_prj.project_id
  location             = var.main_location
  access               = [] # empty for access
}


/*************************************
 IAM Permission
 **************************************/

module "test_bq_data_set_access" {
  source               = "terraform-google-modules/bigquery/google//modules/authorization"
  version              = "~> 5.4.2"

  dataset_id           = module.test_bq_data_set.bigquery_dataset.dataset_id
  project_id           = data.google_project.test_bq_prj.project_id

  roles = concat([
    {
      role             = "roles/bigquery.dataViewer"
      group_by_email   = var.viewer_user_rbac_group
    }
  ],
  [
    {
        role           = "roles/bigquery.dataOwner"
        group_by_email = var.dev_rbac_group
      }
    ]

  )
  authorized_views     = []
}
