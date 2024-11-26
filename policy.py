package spacelift
# Default rule to deny the trigger unless the tag matches the stack name
default allow = false

# Check if the commit has a 'dev' tag and trigger the 'infra_dev' stack
allow {
    input.event == "push"  # Ensure the event is a push (not a pull request, for example)
    some i
    input.push.committer_tags[i] == "dev"  # Check if the 'dev' tag is in the commit
    stack_name("infra_dev")  # Trigger the 'infra_dev' stack
}

# Check if the commit has a 'test' tag and trigger the 'infra_test' stack
allow {
    input.event == "push"  # Ensure the event is a push
    some i
    input.push.committer_tags[i] == "test"  # Check if the 'test' tag is in the commit
    stack_name("infra_test")  # Trigger the 'infra_test' stack
}

# Check if the commit has a 'prod' tag and trigger the 'infra_prod' stack
allow {
    input.event == "push"  # Ensure the event is a push
    some i
    input.push.committer_tags[i] == "prod"  # Check if the 'prod' tag is in the commit
    stack_name("infra_prod")  # Trigger the 'infra_prod' stack
}

# Function to match the stack name based on the tag
stack_name(name) {
    input.stack == name  # Ensure the correct stack is triggered
}
