#!/bin/bash
# Claude-Mates Agent Summoner
# Cross-platform script to launch Claude Code with agent identities
# Compatible with Bash 3.2+ (macOS default)

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

# Agent definitions using functions (Bash 3.2 compatible, no associative arrays)
get_agent_file() {
    case "$1" in
        planner)   echo "Planner_Identity.md" ;;
        builder)   echo "Builder_Identity.md" ;;
        checker)   echo "Checker_Identity.md" ;;
        brainstorm) echo "BrainStorm_Identity.md" ;;
        gal)       echo "Gal_Identity.md" ;;
        legal)     echo "Legal_Identity.md" ;;
        gitdude)   echo "GitDude_Identity.md" ;;
        fetcher)   echo "Fetcher_Identity.md" ;;
        orca)      echo "Orca_Identity.md" ;;
        *)         echo "" ;;
    esac
}

get_agent_name() {
    case "$1" in
        planner)   echo "Planner" ;;
        builder)   echo "Builder" ;;
        checker)   echo "Checker" ;;
        brainstorm) echo "BrainStorm" ;;
        gal)       echo "Gal" ;;
        legal)     echo "Legal" ;;
        gitdude)   echo "GitDude" ;;
        fetcher)   echo "Fetcher" ;;
        orca)      echo "Orca" ;;
        *)         echo "" ;;
    esac
}

# RGB colors for Terminal.app (values 0-65535)
# Format: "R G B" where each is 0-65535
get_agent_color() {
    case "$1" in
        planner)    echo "7710 14906 35466" ;;   # #1E3A8A Blue
        builder)    echo "63993 29555 5654" ;;   # #F97316 Vivid Orange (TEST)
        checker)    echo "5654 25957 13364" ;;   # #166534 Forest Green
        brainstorm) echo "62965 40606 2827" ;;   # #F59E0B Golden Yellow (TEST)
        gal)        echo "3598 29812 37008" ;;   # #0E7490 Teal
        legal)      echo "7710 10537 15163" ;;   # #1E293B Deep Slate
        gitdude)    echo "23387 8481 46774" ;;   # #5B21B6 Deep Violet
        fetcher)    echo "54484 42405 29812" ;;  # #D4A574 Caramel (TEST)
        orca)       echo "6168 6168 6939" ;;     # #18181B Charcoal
        *)          echo "0 0 0" ;;
    esac
}

# Text colors for Terminal.app (values 0-65535)
# Dark backgrounds use off-white, light backgrounds use dark gray
get_agent_text_color() {
    case "$1" in
        builder)    echo "7967 10537 14135" ;;   # #1F2937 Dark (light bg)
        brainstorm) echo "7967 10537 14135" ;;   # #1F2937 Dark (light bg)
        fetcher)    echo "7967 10537 14135" ;;   # #1F2937 Dark (light bg)
        *)          echo "63736 63736 62194" ;;  # #F8F8F2 Off-white (dark bg)
    esac
}

is_valid_agent() {
    case "$1" in
        planner|builder|checker|brainstorm|gal|legal|gitdude|fetcher|orca) return 0 ;;
        *) return 1 ;;
    esac
}

# Preset groups (indexed arrays, Bash 3.2 compatible)
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
    local claude_mates_root=$3
    local agent_key=$4

    # Get hex color for iTerm2 (WCAG AAA compliant)
    local hex_color
    local text_color
    case "$agent_key" in
        planner)    hex_color="#1E3A8A"; text_color="#F8F8F2" ;;  # Blue, white text
        builder)    hex_color="#F97316"; text_color="#1F2937" ;;  # Vivid Orange, dark text
        checker)    hex_color="#166534"; text_color="#F8F8F2" ;;  # Forest Green, white text
        brainstorm) hex_color="#F59E0B"; text_color="#1F2937" ;;  # Golden Yellow, dark text
        gal)        hex_color="#0E7490"; text_color="#F8F8F2" ;;  # Teal, white text
        legal)      hex_color="#1E293B"; text_color="#F8F8F2" ;;  # Deep Slate, white text
        gitdude)    hex_color="#5B21B6"; text_color="#F8F8F2" ;;  # Deep Violet, white text
        fetcher)    hex_color="#D4A574"; text_color="#1F2937" ;;  # Caramel, dark text
        orca)       hex_color="#18181B"; text_color="#F8F8F2" ;;  # Charcoal, white text
        *)          hex_color="#000000"; text_color="#F8F8F2" ;;
    esac

    # Create a launcher script that handles the identity loading
    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${claude_mates_root}'

# Read identity and add startup instruction
IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: Execute your startup protocol immediately.
Read your Memory_Logs, then read the Dashboard, then greet the user.
Do not wait for user input. Begin now."

# Launch claude with identity in system prompt
claude --append-system-prompt "\${IDENTITY}\${STARTUP}"

# Cleanup
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
    local claude_mates_root=$3
    local agent_key=$4

    # Get RGB color values for background
    local colors=$(get_agent_color "$agent_key")
    local r=$(echo "$colors" | cut -d' ' -f1)
    local g=$(echo "$colors" | cut -d' ' -f2)
    local b=$(echo "$colors" | cut -d' ' -f3)

    # Get RGB color values for text
    local text_colors=$(get_agent_text_color "$agent_key")
    local tr=$(echo "$text_colors" | cut -d' ' -f1)
    local tg=$(echo "$text_colors" | cut -d' ' -f2)
    local tb=$(echo "$text_colors" | cut -d' ' -f3)

    # Create a launcher script that handles the identity loading
    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${claude_mates_root}'

# Read identity and add startup instruction
IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: Execute your startup protocol immediately.
Read your Memory_Logs, then read the Dashboard, then greet the user.
Do not wait for user input. Begin now."

# Launch claude with identity in system prompt
claude --append-system-prompt "\${IDENTITY}\${STARTUP}"

# Cleanup
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
    local claude_mates_root=$3
    local agent_key=$4

    # Create a launcher script
    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${claude_mates_root}'
IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: Execute your startup protocol immediately.
Read your Memory_Logs, then read the Dashboard, then greet the user.
Do not wait for user input. Begin now."
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
    local claude_mates_root=$3
    local agent_key=$4

    # Create a launcher script
    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${claude_mates_root}'
IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: Execute your startup protocol immediately.
Read your Memory_Logs, then read the Dashboard, then greet the user.
Do not wait for user input. Begin now."
claude --append-system-prompt "\${IDENTITY}\${STARTUP}"
rm '$launcher_script'
LAUNCHER
    chmod +x "$launcher_script"

    xterm -title "${agent_name}" -e "$launcher_script" &
}

# Linux: konsole (KDE)
launch_konsole() {
    local agent_name=$1
    local identity_path=$2
    local claude_mates_root=$3
    local agent_key=$4

    # Create a launcher script
    local launcher_script=$(mktemp)
    cat > "$launcher_script" << LAUNCHER
#!/bin/bash
cd '${claude_mates_root}'
IDENTITY=\$(cat '${identity_path}')
STARTUP="

---
STARTUP INSTRUCTION: Execute your startup protocol immediately.
Read your Memory_Logs, then read the Dashboard, then greet the user.
Do not wait for user input. Begin now."
claude --append-system-prompt "\${IDENTITY}\${STARTUP}"
rm '$launcher_script'
exec bash
LAUNCHER
    chmod +x "$launcher_script"

    konsole --new-tab -p tabtitle="${agent_name}" -e "$launcher_script" &
}

# Windows: Windows Terminal
launch_windows_terminal() {
    local agent_name=$1
    local identity_path=$2
    local claude_mates_root=$3
    local agent_key=$4

    # Create PowerShell script with identity + startup instruction
    local ps_script=$(mktemp --suffix=.ps1)
    cat > "$ps_script" << LAUNCHER
Set-Location '${claude_mates_root}'
\$identity = Get-Content -Raw '${identity_path}'
\$startup = @"

---
STARTUP INSTRUCTION: Execute your startup protocol immediately.
Read your Memory_Logs, then read the Dashboard, then greet the user.
Do not wait for user input. Begin now.
"@
claude --append-system-prompt (\$identity + \$startup)
Remove-Item '${ps_script}'
LAUNCHER

    wt.exe new-tab --title "${agent_name}" powershell -NoExit -File "$ps_script"
}

# Windows: PowerShell
launch_powershell() {
    local agent_name=$1
    local identity_path=$2
    local claude_mates_root=$3
    local agent_key=$4

    # Create PowerShell script with identity + startup instruction
    local ps_script=$(mktemp --suffix=.ps1)
    cat > "$ps_script" << LAUNCHER
Set-Location '${claude_mates_root}'
\$identity = Get-Content -Raw '${identity_path}'
\$startup = @"

---
STARTUP INSTRUCTION: Execute your startup protocol immediately.
Read your Memory_Logs, then read the Dashboard, then greet the user.
Do not wait for user input. Begin now.
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
            elif command -v konsole &> /dev/null; then
                echo "konsole"
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
    local claude_mates_root=$4
    local agent_key=$5

    case "$launcher" in
        iterm2)           launch_iterm2 "$agent_name" "$identity_path" "$claude_mates_root" "$agent_key" ;;
        terminal_app)     launch_terminal_app "$agent_name" "$identity_path" "$claude_mates_root" "$agent_key" ;;
        gnome_terminal)   launch_gnome_terminal "$agent_name" "$identity_path" "$claude_mates_root" "$agent_key" ;;
        konsole)          launch_konsole "$agent_name" "$identity_path" "$claude_mates_root" "$agent_key" ;;
        xterm)            launch_xterm "$agent_name" "$identity_path" "$claude_mates_root" "$agent_key" ;;
        windows_terminal) launch_windows_terminal "$agent_name" "$identity_path" "$claude_mates_root" "$agent_key" ;;
        powershell)       launch_powershell "$agent_name" "$identity_path" "$claude_mates_root" "$agent_key" ;;
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
            # Split on comma and validate each agent
            local IFS=','
            for agent in $input; do
                # Trim whitespace
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
    # Check for arguments
    if [[ -z "$1" ]]; then
        echo "Claude-Mates Agent Summoner"
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

    # Find Claude-Mates root (current directory should have agents/ folder)
    CLAUDE_MATES_ROOT="$(pwd)"

    # Check if we're in a Claude-Mates repo
    if [[ ! -d "${CLAUDE_MATES_ROOT}/agents" ]]; then
        # Try parent directory
        CLAUDE_MATES_ROOT="$(dirname "$(pwd)")"
        if [[ ! -d "${CLAUDE_MATES_ROOT}/agents" ]]; then
            echo "Error: Not in a Claude-Mates repository"
            echo "Make sure you're in a directory with an 'agents/' folder"
            exit 1
        fi
    fi

    # Get launcher
    LAUNCHER=$(get_launcher)
    if [[ "$LAUNCHER" == "none" ]]; then
        echo "Error: No supported terminal emulator found"
        exit 1
    fi

    echo "Platform: $(detect_platform)"
    echo "Terminal: $LAUNCHER"
    echo "Claude-Mates: $CLAUDE_MATES_ROOT"
    echo ""

    # Parse requested agents (space-separated string)
    TO_LAUNCH=$(parse_agents "$1")

    if [[ -z "$TO_LAUNCH" ]]; then
        echo "Error: No valid agents specified"
        exit 1
    fi

    # Launch agents
    echo "Launching agents..."
    local count=0

    for agent in $TO_LAUNCH; do
        agent_file=$(get_agent_file "$agent")
        agent_name=$(get_agent_name "$agent")
        identity_path="${CLAUDE_MATES_ROOT}/agents/${agent}/${agent_file}"

        if [[ ! -f "$identity_path" ]]; then
            echo "  Warning: Identity not found for $agent at $identity_path"
            continue
        fi

        launch_agent "$LAUNCHER" "$agent_name" "$identity_path" "$CLAUDE_MATES_ROOT" "$agent"
        echo "  + ${agent_name}"
        count=$((count + 1))

        # Small delay to prevent race conditions
        sleep 0.3
    done

    echo ""
    echo "Done! ${count} agent(s) launched."
    echo "Switch windows/tabs to interact with each agent."
}

main "$@"
