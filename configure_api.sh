#!/bin/bash

# Function to validate that input is not empty
validate_input() {
    if [ -z "$1" ]; then
        echo "Error: Input cannot be empty"
        return 1
    fi
    return 0
}

# Function to save configuration to .env file
save_config() {
    # Create or overwrite .env file
    > .env
    # Set restrictive permissions
    chmod 600 .env
    
    # Add configurations based on arguments
    for var in "$@"; do
        echo "$var" >> .env
    done
    
    echo "Configuration saved to .env file"
}

# Clear existing environment variables
clear_env() {
    unset OPENAI_API_KEY
    unset ANTHROPIC_API_KEY
    unset AZURE_OPENAI_API_BASE
    unset AZURE_OPENAI_API_KEY
    unset vLLM_ENDPOINT_URL
}

echo "API Configuration Setup"
echo "======================"

# Present menu options
PS3="Select an API provider (1-4): "
options=("OpenAI" "Anthropic" "Azure OpenAI" "vLLM" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "OpenAI")
            echo "Configuring OpenAI API"
            read -sp "Enter your OpenAI API key: " api_key
            echo
            if validate_input "$api_key"; then
                clear_env
                save_config "OPENAI_API_KEY=$api_key"
                break
            fi
            ;;
            
        "Anthropic")
            echo "Configuring Anthropic API"
            read -sp "Enter your Anthropic API key: " api_key
            echo
            if validate_input "$api_key"; then
                clear_env
                save_config "ANTHROPIC_API_KEY=$api_key"
                break
            fi
            ;;
            
        "Azure OpenAI")
            echo "Configuring Azure OpenAI API"
            read -p "Enter your Azure OpenAI deployment name: " deployment_name
            read -sp "Enter your Azure OpenAI API key: " api_key
            echo
            if validate_input "$deployment_name" && validate_input "$api_key"; then
                clear_env
                save_config "AZURE_OPENAI_API_BASE=$deployment_name" "AZURE_OPENAI_API_KEY=$api_key"
                break
            fi
            ;;
            
        "vLLM")
            echo "Configuring vLLM"
            read -p "Enter your vLLM endpoint URL: " endpoint_url
            echo
            if validate_input "$endpoint_url"; then
                clear_env
                save_config "vLLM_ENDPOINT_URL=$endpoint_url"
                break
            fi
            ;;
            
        "Quit")
            echo "Exiting..."
            exit 0
            ;;
            
        *)
            echo "Invalid option. Please select a number between 1-4"
            ;;
    esac
done

echo "Configuration completed successfully!"

