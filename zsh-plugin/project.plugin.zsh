_project() {
    local -a commands
    commands=(
        'add:Register a folder as a project'
        'remove:Unregister a project'
        'list:Show all registered projects'
        'open:Open project on a new i3 workspace'
        'help:Show usage information'
    )

    _arguments -C \
        '1:command:->command' \
        '*::arg:->args'

    case $state in
        command)
            _describe 'command' commands
            ;;
        args)
            case $words[1] in
                open|remove)
                    local -a projects
                    if [[ -f ~/.config/project/registry ]]; then
                        projects=(${(f)"$(cut -d: -f1 ~/.config/project/registry)"})
                    fi
                    _describe 'project' projects
                    ;;
                add)
                    _files -/
                    ;;
            esac
            ;;
    esac
}
compdef _project project
