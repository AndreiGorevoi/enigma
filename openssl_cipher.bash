#!usr/bin/env bash
ceasar_value=3

decrypt_file() {
    echo "Enter the filename:"
    read file_name
    if [ ! -e "$file_name" ]; then
        echo "File not found!"
    else
        echo "Enter password:"
        read password
        openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$file_name" -out "${file_name%.enc}" -pass pass:"$password" &>/dev/null
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo "Fail"
        else
            rm "$file_name"
            echo "Success"
        fi
    fi
}

encrypt_file() {
    echo "Enter the filename:"
    read file_name
    if [ ! -e "$file_name" ]; then
        echo "File not found!"
    else
        echo "Enter password:"
        read password
        openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$file_name" -out "${file_name}.enc" -pass pass:"$password" &>/dev/null
        exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            echo "Fail"
        else
            rm "$file_name"
            echo "Success"
        fi
    fi
}

read_file() {
    echo "Enter the filename:"
    read file_name_input

    if [ ! -e "$file_name_input" ]; then
        echo "File not found!"
    else
        echo "File content:"
        cat "$file_name_input"
    fi
}

create_file() {
    echo "Enter the filename:"
    read file_name

    if [[ ! "$file_name" =~ ^[a-zA-Z.]+$ ]]; then
        echo "File name can contain letters and dots only!"
    else
        echo "Enter a message:"
        read msg
        if [[ ! "$msg" =~ ^[A-Z[:space:]]+$ ]]; then
            echo "This is not a valid message!"
        else
            echo "$msg" > "$file_name"
            echo "The file was created successfully!"
        fi
    fi
}


menu() {
    echo
    echo "0. Exit"
    echo "1. Create a file"
    echo "2. Read a file"
    echo "3. Encrypt a file"
    echo "4. Decrypt a file"
    echo "Enter an option:"
    read operation
    if [[ ! "$operation" =~ ^[0-4]$ ]]; then
        echo "Invalid option!"
        return
    fi
    case "$operation" in
        "1")
            create_file
        ;;
        "2")
            read_file
        ;;
        "3")
            encrypt_file
        ;;
        "4")
            decrypt_file
        ;;
        "0")
            echo "See you later!"
            exit
            ;;
    esac
}

echo "Welcome to the Enigma!"

while true; do
    menu
done
