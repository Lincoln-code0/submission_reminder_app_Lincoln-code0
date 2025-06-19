
#!/bin/bash

#prompting user
read -p "enter your name:" user_input 


dir="submission_reminder_$user_input"

mkdir -p "$dir"/{app,modules,assets,config}


cat << 'EOL' >"$dir/app/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOL

cat << 'EOL' > "$dir/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOL

#adding more five students
cat << 'EOL' > "$dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Kevin, Shell Basics, not submitted
Lincoln, Git, not submitted
Dorcas, Shell Navigation, submitted
Melody, shell Basics, submitted
Frank, Shell Interpritation, not submitted
EOL

cp ~/config.env "$dir/config/config.env"
chmod +x "$dir/app/reminder.sh"
chmod +x "$dir/modules/functions.sh"


cat << 'EOL' > "$dir/startup.sh"
#!/bin/bash
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$path"
source ./config/config.env
source ./modules/functions.sh
bash ./app/reminder.sh
EOL
chmod +x "$dir/startup.sh"

echo "done"


