{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    terminal = "screen-256color";
    baseIndex = 1;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = mkTmuxPlugin {
          pluginName = "smart-splits.nvim";
          version = "2.1.0";
          src = pkgs.fetchFromGitHub {
            owner = "mrjones2014";
            repo = "smart-splits.nvim";
            rev = "v2.1.0";
            hash = "sha256-IuJNQT0bN68K5lnw0ixyU/heG8V1+zUwlvm0mNvvHOw=";
          };
          rtpFilePath = "smart-splits.tmux";
          meta = {
            homepage = "https://github.com/mrjones2014/smart-splits.nvim";
            description = "🧠 Smart, seamless, directional navigation and resizing of Neovim + terminal multiplexer splits. Supports Zellij, Tmux, Wezterm, and Kitty. Think about splits in terms of \"up/down/left/right\".";
          };
        };
        extraConfig = ''
          set -g @smart-splits_no_wrap \'\' # to disable wrapping. (any value disables wrapping)

          set -g @smart-splits_move_left_key  'C-h' # key-mapping for navigation.
          set -g @smart-splits_move_down_key  'C-j' #  --"--
          set -g @smart-splits_move_up_key    'C-k' #  --"--
          set -g @smart-splits_move_right_key 'C-l' #  --"--

          set -g @smart-splits_resize_left_key  'M-h' # key-mapping for resizing.
          set -g @smart-splits_resize_down_key  'M-j' #  --"--
          set -g @smart-splits_resize_up_key    'M-k' #  --"--
          set -g @smart-splits_resize_right_key 'M-l' #  --"--

          set -g @smart-splits_resize_step_size '5' # change the step-size for resizing.
        '';
      }
    ];
    extraConfig = ''
      set -g pane-base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on

      set -ga terminal-override ",*256col*:Tc"

      set -g set-clipboard on
      set -g status-interval 1

      bind x kill-pane

      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      unbind %
      bind \\ split-window -h -c "#{pane_current_path}"

      unbind \"
      bind - split-window -v -c "#{pane_current_path}"

      bind -r M-j resize-pane -D 5
      bind -r M-k resize-pane -U 5
      bind -r M-h resize-pane -L 5
      bind -r M-l resize-pane -R 5

      bind -r m resize-pane -Z

      set -g mode-keys vi
      set -g status-keys vi

      unbind v
      bind v copy-mode
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi C-v send -X rectangle-toggle
      bind-key -T copy-mode-vi y send -X copy-selection
      bind-key -T copy-mode-vi Escape send -X cancel

      unbind -T copy-mode-vi MouseDragEnd1Pane

      bind C-y display-popup -d "#{pane-current-path}" -w 90% -h 90% -E "yazi" # yazi float
      bind C-g display-popup -d "#{pane-current-path}" -w 90% -h 90% -E "lazygit" # lazygit float

      set -g status-position top
      set -g status-justify left

      set -g status-left '#[#{?client_prefix,bg=white\,fg=black,}] tmux '
      set -g status-right ""
    '';
  };
}
