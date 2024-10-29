# Introduction 
Creates a Storage Account with the following naming convention: st-(storage name)-(instance number)

Exp: st-mystorage-001

# Parameters
| Variable      | Description |
| :---        |    :----   |
| storage_account_name      | Name of the storage account       |
| instance_number   | Instance number used to build the RG name        |
| location   | The Azure Region where the Resource Group should exist.        |
| resource_group_name           | Specifies the Resource Group where the Storage Account should exist.   |
| account_tier   | (Optional) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Defaults to Standard.        |
| account_replication_type   | (Optional) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Defaults to GRS.        |
| account_kind   | (Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2.        |
| access_tier   | (Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot.        |
| tags   | (Optional) A mapping of tags to assign to the resource.        |

# Outputs
| Output      | Description |
| :---        |    :----   |
| storage_account_name   | Name of the storage account. |