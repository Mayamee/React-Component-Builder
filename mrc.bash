#!/bin/bash

EXT="jsx"
STYLE_EXT="scss"

GREEN='32'
RED='31'
function cecho() {
	echo -e "\e[1;$2m$1\e[0m"
}

function validate_value_required() {
	if [ -z "$1" ]; then
		cecho "Name is required" $RED
		exit 1
	fi
}

# Read Value from prompt
function read_value() {
	read -p "$1" value
	value=$(echo -e "${value}" | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//')
	echo "$value"
}

# Replace value if it is not provided
function replace_empty_value() {
	if [ -z "$2" ]; then
		echo "$1"
	else
		echo "$2"
	fi
}

# Map y/n to true/false
function map_yn() {
	if [ "$1" == "y" ]; then
		echo true
	else
		echo false
	fi
}

# Scan directory for check if component exists
function scan_directory() {
	if [ -d "$1" ]; then
		echo true
	else
		echo false
	fi
}

# Validate if component exists
function validate_component_exists() {
	if [ "$(scan_directory "$COMPONENT_NAME")" == "true" ]; then
		cecho "Component already exists" $RED
		exit 1
	fi
}

COMPONENT_NAME=$(read_value "Enter component name: ") &&
	validate_value_required "$COMPONENT_NAME" && validate_component_exists

COMPONENT_EXTENSION=$(replace_empty_value "$EXT" "$(read_value "Component extention? [$EXT]: ")")

STYLE_PREPROCESSOR=$(replace_empty_value "$STYLE_EXT" "$(read_value "Style preprocessor? [$STYLE_EXT]: ")")

IS_USE_MODULES=$(map_yn "$(replace_empty_value "y" "$(read_value "Use modules (y/n)? [y]: ")")")

# Create component directory
mkdir -p "$COMPONENT_NAME" && cecho "Component $COMPONENT_NAME directory created" $GREEN
touch "$COMPONENT_NAME/$COMPONENT_NAME.$COMPONENT_EXTENSION" && cecho "Component $COMPONENT_NAME.$COMPONENT_EXTENSION file created" $GREEN
# if modules are used, append .module extention to style component file name
if [ "$IS_USE_MODULES" == "true" ]; then
	touch "$COMPONENT_NAME/$COMPONENT_NAME.module.$STYLE_PREPROCESSOR" && cecho "Component $COMPONENT_NAME.module.$STYLE_PREPROCESSOR file created" $GREEN
else
	touch "$COMPONENT_NAME/$COMPONENT_NAME.$STYLE_PREPROCESSOR" && cecho "Component $COMPONENT_NAME.$STYLE_PREPROCESSOR file created" $GREEN
fi
