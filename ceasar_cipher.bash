#!usr/bin/env bash
ceasar_value=3

encrypt_msg() {
    res=""
    for ((i=0; i< ${#1}; i++)); do
    letter="${1:i:1}"
        case "$letter" in
            ' ')
                res="${res} "
                ;;
            *)
                value=$(printf "%d\n" "'$letter")
                new_value=$(( $value + $ceasar_value ))
                if [ $new_value -gt 90 ]; then
                    new_value=$(( $new_value - 26 ))
                fi
                final_letter=$(printf "%b\n" "$(printf "\\%03o" "$new_value")")
                res="$res$final_letter"
            ;;
        esac
    done
    echo "$res"
}

decrypt_msg() {
    res=""
    for ((i=0; i< ${#1}; i++)); do
    letter="${1:i:1}"
        case "$letter" in
            ' ')
                res="${res} "
                ;;
            *)
                value=$(printf "%d\n" "'$letter")
                new_value=$(( $value - $ceasar_value ))
                if [ $new_value -lt 65 ]; then
                    new_value=$(( $new_value + 26 ))
                    fi
                    final_letter=$(printf "%b\n" "$(printf "\\%03o" "$new_value")")
                    res="$res$final_letter"
                    ;;
        esac
    done
    echo "$res"
}

decrypt_file() {
    echo "Enter the filename:"
    read file_name
    if [ ! -e "$file_name" ]; then
        echo "File not found!"
        else
        content=$(decrypt_msg "$(cat $file_name)")
        echo "$content" > "${file_name%.enc}"
        rm "$file_name"
        echo "Success"
    fi
}

encrypt_file() {
    echo "Enter the filename:"
    read file_name
    if [ ! -e "$file_name" ]; then
        echo "File not found!"
    else
        content=$(encrypt_msg "$(cat $file_name)")
        echo "$content" > "${file_name}.enc"
        rm "$file_name"
        echo "Success"
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
