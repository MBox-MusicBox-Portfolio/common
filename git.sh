#!/bin/bash

# Script developed by Sergey Zhyltsov
#This script automates the project building process for microservices on your local machine, including checking and installing required software programs . Creating necessary project directories with pulling code repositories
 
# List of required programs. Add new program name here for installing software 
# IMPORTANT: Do not forget added new condition to the InstallProgram function 
#git@gitlab.musicbox.local:music-box/temp.git
programs=("git" "ssh" "openvpn")

# Workdir where's project location
project_dir="$HOME/Документы/MusicBox"

# Base URL for repositories
repo_base_url="git@gitlab.musicbox.local:music-box"

# Map of project directories relative to the project_dir and their corresponding repository URLs
declare -A directory_repository_map=(
    		  ["$project_dir/api/auth"]="$repo_base_url/back-end/auth.git"
   		  ["$project_dir/api/admin"]="$repo_base_url/back-end/admin.git"
   		  ["$project_dir/api/public"]="$repo_base_url/back-end/public.git"
   		  ["$project_dir/consumer/event.route"]="$repo_base_url/consumer/event.route.git"
   		  ["$project_dir/consumer/mailer"]="$repo_base_url/consumer/mailer.git"
   		  ["$project_dir/consumer/socket.emitter"]="$repo_base_url/consumer/socket.emitter.git"
   		  ["$project_dir/consumer/socket.instance"]="$repo_base_url/consumer/socket.instance.git"
    		  ["$project_dir/frontend/admin"]="$repo_base_url/front-end/admin.git"
    		  ["$project_dir/frontend/public"]="$repo_base_url/front-end/public.git"
    		  ["$project_dir"]="$repo_base_url/temp.git"
)

#Config access to gitlab 
function SetAccessConfig()
{
   local answer=""
    while true; do
        echo "Do you have an SSH access key? [y/n]"
        read -r answer 

        if [[ "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" ]]; then       
            eval "$(ssh-agent -s)"
            ssh-add ~/.ssh/id_rsa
            break
        elif [[ "$answer" == "n" || "$answer" == "N" || "$answer" == "no" ]]; then
            local inbox=""
            echo "Enter GitLab inbox name: " 
            read -r inbox
            ssh-keygen -t rsa -b 4096 -C "$inbox"
            eval "$(ssh-agent -s)"
            ssh-add ~/.ssh/id_rsa
            break
        else
            echo "Invalid input. Please enter 'y' or 'n'."
        fi
    done
}

#Installation needed utilities.
#So when we added new name to the lists of required programs , you need to add new condition here
function InstallProgram()
{
    local program="$1"
    case "$program" in
        git)
            echo "Installing $program..."
            sudo apt install git -y
            ;;
        ssh)
            echo "Installing $program..."
             sudo apt install ssh
             sudo systemctl enable sshd
            ;;
        openvpn)
            echo "Installing $program..."
            sudo apt install openvpn -y
            ;;
        *)
            echo "Unknown program: $program"
            ;;
    esac
}

#Check software installation 
function CheckSoftwareInstallation()
{ 
  local results=" "
     for program in "${programs[@]}"; do
    	   if which "$program" > /dev/null; then
        	   results+="[$program: Success] "
        	#return 0
    	   else
        	#results+="[$program: Failure] "
        	InstallProgram "$program"
    	   fi
      done
echo "Check software installation: $results " 				 
}

# Create Project Directory and return true if successful, false otherwise
function CreateFolder()
{
    local directory="$1"
    if [ -d "$directory" ]; then
           return 0 # Success
    else
           mkdir -p "$directory"
        #return 1 # Failure
    fi     
}

# Pulls changes from the current repository
function GitPullChanges()
{
    local repoLinked="$1"
    rm -rf .git
    	git init
    	      git config --global init.defaultBranch main
    	      git config --global http.sslverify false
    	      git branch -M main
    	      git remote add origin "$repoLinked"
    	git pull origin main
}


function Start()
{
    CheckSoftwareInstallation
    local installation_result=$?
    if [ "$installation_result" -eq 0 ]; then
        for dir in "${!directory_repository_map[@]}"; do
            if CreateFolder "$dir"; then
                 cd "$dir"
                 GitPullChanges "${directory_repository_map[$dir]}"  
            else
                 echo "The directory $dir doesn't exist and will be created ..."
                 ls "$dir"
            fi        
        done
        echo "Search project directory ...  $directory"  
    else
        echo "Software installation failed, cannot continue."
    fi
       unset directory_repository_map
    unset programs 
}
# Running
Start

