#!/bin/bash

# Set the number of storage accounts to move (adjust if needed)
indexes=(0 1 2 3)

# Define old and new module roots
OLD_ROOT_NS='module.region_resources["NS"].module.storage'
NEW_ROOT_NS='module.storage["NS"]'

OLD_ROOT_WE='module.region_resources["WE"].module.storage'
NEW_ROOT_WE='module.storage["WE"]'

# Move NS storage accounts
for i in "${indexes[@]}"; do
  terraform state mv \
    "${OLD_ROOT_NS}.azurerm_storage_account.storage[${i}]" \
    "${NEW_ROOT_NS}.azurerm_storage_account.storage[${i}]"
done

# Move NS random string
terraform state mv \
  "${OLD_ROOT_NS}.random_string.suffix" \
  "${NEW_ROOT_NS}.random_string.suffix"

# Move WE storage accounts
for i in "${indexes[@]}"; do
  terraform state mv \
    "${OLD_ROOT_WE}.azurerm_storage_account.storage[${i}]" \
    "${NEW_ROOT_WE}.azurerm_storage_account.storage[${i}]"
done

# Move WE random string
terraform state mv \
  "${OLD_ROOT_WE}.random_string.suffix" \
  "${NEW_ROOT_WE}.random_string.suffix"
