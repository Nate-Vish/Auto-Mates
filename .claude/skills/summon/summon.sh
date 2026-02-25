#!/bin/bash
# AutoMates Agent Summoner
# Cross-platform script to launch Claude Code with agent identities
# Compatible with Bash 3.2+ (macOS default)
# Adapted for AgenTeam directory structure

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

# Agent identity file paths (relative to project root)
get_agent_identity_path() {
    case "$1" in
        planner)    echo "AgenTeam/Planner/Planner_Identity.md" ;;
        builder)    echo "AgenTeam/Builder/Builder_Identity.md" ;;
        checker)    echo "AgenTeam/Checker/Checker_Identity.md" ;;
        brainstorm) echo "AgenTeam/BrainStorm/BrainStorm_Identity.md" ;;
        gal)        echo "AgenTeam/Gal/Gal_Identity.md" ;;
        legal)      echo "AgenTeam/Legal/Legal_Identity.md" ;;
        gitdude)    echo "AgenTeam/GitDude/GitDude_Identity.md" ;;
        fetcher)    echo "Library/Fetcher/Fetcher_Identity.md" ;;
        orca)       echo "AgenTeam/Orca/Orca_Identity.md" ;;
        *)          echo "" ;;
    esac
}

get_agent_name() {
    case "$1" in
        planner)    echo "Planner" ;;
        builder)    echo "Builder" ;;
        checker)    echo "Checker" ;;
        brainstorm) echo "BrainStorm" ;;
        gal)        echo "Gal" ;;
        legal)      echo "Legal" ;;
        gitdude)    echo "GitDude" ;;
        fetcher)    echo "Fetcher" ;;
        orca)       echo "Orca" ;;
        *)          echo "" ;;
    esac
}

# RGB colors for Terminal.app (values 0-65535)
get_agent_color() {
    case "$1" in
        planner)    echo "7710 14906 35466" ;;   # #1E3A8A Blue
        builder)    echo "63993 29555 5654" ;;    # #F97316 Vivid Orange
        checker)    echo "5654 25957 13364" ;;    # #166534 Forest Green
        brainstorm) echo "62965 40606 2827" ;;    # #F59E0B Golden Yellow
        gal)        echo "3598 29812 37008" ;;    # #0E7490 Teal
        legal)      echo "7710 10537 15163" ;;    # #1E293B Deep Slate
        gitdude)    echo "23387 8481 46774" ;;    # #5B21B6 Deep Violet
        fetcher)    echo "54484 42405 29812" ;;   # #D4A574 Caramel
        orca)       echo "6168 6168 6939" ;;      # #18181B Charcoal
        *)          echo "0 0 0" ;;
    esac
}

# Text colors for Terminal.app
get_agent_text_color() {
    case "$1" in
        builder)    echo "7967 10537 14135" ;;    # Dark text for light bg
        brainstorm) echo "7967 10537 14135" ;;
        fetcher)    echo "7967 10537 14135" ;;
        *)          echo "63736 63736 62194" ;;   # Off-white for dark bg
    esac
}

is_valid_agent() {
    case "$1" in
        planner|builder|checker|brainstorm|gal|legal|gitdude|fetcher|orca) return 0 ;;
        *) return 1 ;;
    esac
}

# Preset groups
TEAM_AGENTS="planner builder checker"
ALL_AGENTS="planner builder checker brainstorm gal legal gitdude fetcher orca"

# ============================================================================
# PLATFORM DETECTION
# ============================================================================

detect_platform() {
    case "$(uname -s)" in
        Darwin*)    echo "macos" ;;
        Linux*)     echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)          echo "unknown" ;;
    esac
}

# ============================================================================
# TERMINAL LAUNCHERS
# ============================================================================

# macOS: iTerm2
launch_iterm2() {
    local agent_name=$1
    local identity_path=$2
    local project_root=$3
    local agent_key=$4

    local hex_color text_color
    case "$agent_key" in
        planner)    hex_color="#1E3A8A"; text_color="#F8F8F2" ;;
        builder)    hex_color="#F97316"; text_color="#1F2937" ;;
        checker)    hex_color="#166534"; text_color="#F8F8F2" ;;
        brainstorm) hex_color="#F59E0B"; text_color="#1F2937" ;;
        gal)        hex_color="#0E7490"; text_color="#F8F8F2" ;;
        legal)      hex_color="#1E293B"; text_color="#F8F8F2" ;;
        gitdude)    hex_color="#5B21B6"; text_color="#F8F8F2" ;;
        fetcher)    hex_color="#D4A574"; text_color="#1F2937" ;;
        orca)       hex_color="#18181B"; text_color="#F8F8F2" ;;
        *)          hex_color="#000000"; text_color="#F8F8F2" ;;
    esac

    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${project_root}'

# Read identity and add startup instruction
IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: You are an AutoMates agent. Execute your startup protocol:
1. You've just read your identity (above).
2. Read your Memory_Logs (Checkpoint, Lessons, Preferences, latest Session).
3. Read Dashboard (Brief.md).
4. Read your knowledge section from Library/Knowledge/.
5. Greet the user and ask what they'd like you to work on.
Begin now."

# Launch claude with identity in system prompt
claude --append-system-prompt "\${IDENTITY}\${STARTUP}"

rm '$launcher_script'
LAUNCHER
    chmod +x "$launcher_script"

    osascript <<EOF
tell application "iTerm2"
    if (count of windows) = 0 then
        create window with default profile
    end if
    tell current window
        create tab with default profile
        tell current session
            write text "'${launcher_script}'"
            set name to "${agent_name}"
            set background color to "${hex_color}"
            set foreground color to "${text_color}"
        end tell
    end tell
end tell
EOF
}

# macOS: Terminal.app
launch_terminal_app() {
    local agent_name=$1
    local identity_path=$2
    local project_root=$3
    local agent_key=$4

    local colors=$(get_agent_color "$agent_key")
    local r=$(echo "$colors" | cut -d' ' -f1)
    local g=$(echo "$colors" | cut -d' ' -f2)
    local b=$(echo "$colors" | cut -d' ' -f3)

    local text_colors=$(get_agent_text_color "$agent_key")
    local tr=$(echo "$text_colors" | cut -d' ' -f1)
    local tg=$(echo "$text_colors" | cut -d' ' -f2)
    local tb=$(echo "$text_colors" | cut -d' ' -f3)

    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${project_root}'

IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: You are an AutoMates agent. Execute your startup protocol:
1. You've just read your identity (above).
2. Read your Memory_Logs (Checkpoint, Lessons, Preferences, latest Session).
3. Read Dashboard (Brief.md).
4. Read your knowledge section from Library/Knowledge/.
5. Greet the user and ask what they'd like you to work on.
Begin now."

claude --append-system-prompt "\${IDENTITY}\${STARTUP}"

rm '$launcher_script'
LAUNCHER
    chmod +x "$launcher_script"

    osascript <<EOF
tell application "Terminal"
    activate
    do script "'${launcher_script}'"
    delay 0.5
    set background color of selected tab of front window to {${r}, ${g}, ${b}}
    set normal text color of selected tab of front window to {${tr}, ${tg}, ${tb}}
    set the custom title of front window to "${agent_name}"
end tell
EOF
}

# Linux: gnome-terminal
launch_gnome_terminal() {
    local agent_name=$1
    local identity_path=$2
    local project_root=$3

    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${project_root}'
IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: You are an AutoMates agent. Execute your startup protocol:
1. You've just read your identity (above).
2. Read your Memory_Logs (Checkpoint, Lessons, Preferences, latest Session).
3. Read Dashboard (Brief.md).
4. Read your knowledge section from Library/Knowledge/.
5. Greet the user and ask what they'd like you to work on.
Begin now."
claude --append-system-prompt "\${IDENTITY}\${STARTUP}"
rm '$launcher_script'
exec bash
LAUNCHER
    chmod +x "$launcher_script"

    gnome-terminal --tab --title="${agent_name}" -- "$launcher_script"
}

# Linux: xterm
launch_xterm() {
    local agent_name=$1
    local identity_path=$2
    local project_root=$3

    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${project_root}'
IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: You are an AutoMates agent. Execute your startup protocol:
1. You've just read your identity (above).
2. Read your Memory_Logs (Checkpoint, Lessons, Preferences, latest Session).
3. Read Dashboard (Brief.md).
4. Read your knowledge section from Library/Knowledge/.
5. Greet the user and ask what they'd like you to work on.
Begin now."
claude --append-system-prompt "\${IDENTITY}\${STARTUP}"
rm '$launcher_script'
LAUNCHER
    chmod +x "$launcher_script"

    xterm -title "${agent_name}" -e "$launcher_script" &
}

# Windows: Windows Terminal
launch_windows_terminal() {
    local agent_name=$1
    local identity_path=$2
    local project_root=$3

    local ps_script=$(mktemp --suffix=.ps1)
    cat > "$ps_script" << LAUNCHER
Set-Location '${project_root}'
\$identity = Get-Content -Raw '${identity_path}'
\$startup = @"

---
STARTUP INSTRUCTION: You are an AutoMates agent. Execute your startup protocol:
1. You've just read your identity (above).
2. Read your Memory_Logs (Checkpoint, Lessons, Preferences, latest Session).
3. Read Dashboard (Brief.md).
4. Read your knowledge section from Library/Knowledge/.
5. Greet the user and ask what they'd like you to work on.
Begin now.
"@
claude --append-system-prompt (\$identity + \$startup)
Remove-Item '${ps_script}'
LAUNCHER

    wt.exe new-tab --title "${agent_name}" powershell -NoExit -File "$ps_script"
}

# Windows: PowerShell fallback
launch_powershell() {
    local agent_name=$1
    local identity_path=$2
    local project_root=$3

    local ps_script=$(mktemp --suffix=.ps1)
    cat > "$ps_script" << LAUNCHER
Set-Location '${project_root}'
\$identity = Get-Content -Raw '${identity_path}'
\$startup = @"

---
STARTUP INSTRUCTION: You are an AutoMates agent. Execute your startup protocol:
1. You've just read your identity (above).
2. Read your Memory_Logs (Checkpoint, Lessons, Preferences, latest Session).
3. Read Dashboard (Brief.md).
4. Read your knowledge section from Library/Knowledge/.
5. Greet the user and ask what they'd like you to work on.
Begin now.
"@
claude --append-system-prompt (\$identity + \$startup)
Remove-Item '${ps_script}'
LAUNCHER

    powershell.exe -Command "Start-Process powershell -ArgumentList '-NoExit', '-File', '${ps_script}'"
}

# ============================================================================
# LAUNCHER SELECTION
# ============================================================================

get_launcher() {
    local platform=$(detect_platform)

    case "$platform" in
        macos)
            if [[ -d "/Applications/iTerm.app" ]] || [[ -d "$HOME/Applications/iTerm.app" ]]; then
                echo "iterm2"
            else
                echo "terminal_app"
            fi
            ;;
        linux)
            if command -v gnome-terminal &> /dev/null; then
                echo "gnome_terminal"
            elif command -v xterm &> /dev/null; then
                echo "xterm"
            else
                echo "none"
            fi
            ;;
        windows)
            if command -v wt.exe &> /dev/null; then
                echo "windows_terminal"
            else
                echo "powershell"
            fi
            ;;
        *)
            echo "none"
            ;;
    esac
}

launch_agent() {
    local launcher=$1
    local agent_name=$2
    local identity_path=$3
    local project_root=$4
    local agent_key=$5

    case "$launcher" in
        iterm2)           launch_iterm2 "$agent_name" "$identity_path" "$project_root" "$agent_key" ;;
        terminal_app)     launch_terminal_app "$agent_name" "$identity_path" "$project_root" "$agent_key" ;;
        gnome_terminal)   launch_gnome_terminal "$agent_name" "$identity_path" "$project_root" ;;
        xterm)            launch_xterm "$agent_name" "$identity_path" "$project_root" ;;
        windows_terminal) launch_windows_terminal "$agent_name" "$identity_path" "$project_root" ;;
        powershell)       launch_powershell "$agent_name" "$identity_path" "$project_root" ;;
        *)
            echo "Error: No supported terminal found"
            exit 1
            ;;
    esac
}

# ============================================================================
# ARGUMENT PARSING
# ============================================================================

parse_agents() {
    local input=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    local agents=""

    case "$input" in
        "all")
            agents="$ALL_AGENTS"
            ;;
        "team")
            agents="$TEAM_AGENTS"
            ;;
        *)
            local IFS=','
            for agent in $input; do
                agent=$(echo "$agent" | tr -d ' ')
                if is_valid_agent "$agent"; then
                    agents="$agents $agent"
                else
                    echo "Warning: Unknown agent '$agent', skipping"
                fi
            done
            ;;
    esac

    echo "$agents"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    if [[ -z "$1" ]]; then
        echo "AutoMates Agent Summoner"
        echo ""
        echo "Usage: summon.sh <agent1,agent2,...|team|all>"
        echo ""
        echo "Examples:"
        echo "  summon.sh planner           # Launch Planner"
        echo "  summon.sh builder,checker   # Launch Builder and Checker"
        echo "  summon.sh team              # Launch Planner, Builder, Checker"
        echo "  summon.sh all               # Launch all 9 agents"
        echo ""
        echo "Available agents:"
        echo "  planner, builder, checker, brainstorm, gal"
        echo "  legal, gitdude, fetcher, orca"
        exit 0
    fi

    PROJECT_ROOT="$(pwd)"

    # Check if we're in the AutoMates project
    if [[ ! -d "${PROJECT_ROOT}/AgenTeam" ]]; then
        # Try parent directory
        PROJECT_ROOT="$(dirname "$(pwd)")"
        if [[ ! -d "${PROJECT_ROOT}/AgenTeam" ]]; then
            echo "Error: Not in the AutoMates project"
            echo "Make sure you're in a directory with an 'AgenTeam/' folder"
            exit 1
        fi
    fi

    LAUNCHER=$(get_launcher)
    if [[ "$LAUNCHER" == "none" ]]; then
        echo "Error: No supported terminal emulator found"
        exit 1
    fi

    echo "Platform: $(detect_platform)"
    echo "Terminal: $LAUNCHER"
    echo "Project:  $PROJECT_ROOT"
    echo ""

    TO_LAUNCH=$(parse_agents "$1")

    if [[ -z "$TO_LAUNCH" ]]; then
        echo "Error: No valid agents specified"
        exit 1
    fi

    echo "Launching agents..."
    local count=0

    for agent in $TO_LAUNCH; do
        agent_identity=$(get_agent_identity_path "$agent")
        agent_name=$(get_agent_name "$agent")
        identity_path="${PROJECT_ROOT}/${agent_identity}"

        if [[ ! -f "$identity_path" ]]; then
            echo "  Warning: Identity not found for $agent at $identity_path"
            continue
        fi

        launch_agent "$LAUNCHER" "$agent_name" "$identity_path" "$PROJECT_ROOT" "$agent"
        echo "  + ${agent_name}"
        count=$((count + 1))

        sleep 0.3
    done

    echo ""
    echo "Done! ${count} agent(s) launched."
    echo "Switch windows/tabs to interact with each agent."
}

main "$@"
