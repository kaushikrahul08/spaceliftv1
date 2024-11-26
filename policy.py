# Default rule to deny the trigger unless the tag matches the stack name
default allow = false

# Check if the commit has a 'dev' tag and trigger the 'infra_dev' stack
allow {
    input.event == "push"  # Ensure the event is a push
    some i
    input.push.committer_tags[i] == "dev"  # Check for 'dev' tag in the commit
    stack_name("infra_dev")  # Trigger the 'infra_dev' stack
}

# Check if the commit has a 'prod' tag and trigger the 'infra_prod' stack
allow {
    input.event == "push"  # Ensure the event is a push
    some i
    input.push.committer_tags[i] == "test"  # Check for 'prod' tag in the commit
    stack_name("infra_test")  # Trigger the 'infra_prod' stack
}

# Check if the commit has a 'prod' tag and trigger the 'infra_prod' stack
allow {
    input.event == "push"  # Ensure the event is a push
    some i
    input.push.committer_tags[i] == "prod"  # Check for 'prod' tag in the commit
    stack_name("infra_prod")  # Trigger the 'infra_prod' stack
}

# Function to match the stack name based on the tag
stack_name(name) {
    # Match the full stack name (e.g., "infra_dev" or "infra_prod")
    input.stack == name
}