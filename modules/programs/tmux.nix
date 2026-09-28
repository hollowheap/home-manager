{ pkgs, ... }:

let
  black = "#000000";

  colors = [
    "brightcyan"
    "brightblue"
    "brightmagenta"
    "brightgreen"
    "brightyellow"
    "brightred"
    "brightwhite"
  ];

  mkColorCycle =
    cols:
    let
      len = builtins.length cols;
      buildCond =
        i:
        if i == len - 1 then
          builtins.elemAt cols i
        else
          "#{?#{==:#{e|%:#{window_index},${toString len}},${toString (i + 1)}},${builtins.elemAt cols i},${buildCond (i + 1)}}";
    in
    buildCond 0;

  windowColor = mkColorCycle colors;
  sessionColor = "#{?client_prefix,white,brightblack}";
in
{
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    terminal = "tmux-256color";
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

          set -g @smart-splits_move_left_key  'M-h' # key-mapping for navigation with Alt
          set -g @smart-splits_move_down_key  'M-j' #  --"--
          set -g @smart-splits_move_up_key    'M-k' #  --"--
          set -g @smart-splits_move_right_key 'M-l' #  --"--

          set -g @smart-splits_resize_left_key  'C-h' # key-mapping for resizing with Ctrl
          set -g @smart-splits_resize_down_key  'C-j' #  --"--
          set -g @smart-splits_resize_up_key    'C-k' #  --"--
          set -g @smart-splits_resize_right_key 'C-l' #  --"--

          set -g @smart-splits_resize_step_size '5' # change the step-size for resizing.
        '';
      }
    ];
    extraConfig = ''
      set -g pane-base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on

      set -as terminal-features ",*:RGB"
      set -ga terminal-overrides ",*:Tc"

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

      bind C-y display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "yazi" # yazi float
      bind C-g display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "lazygit" # lazygit float

      # Status bar configuration
      set -g status-position top
      set -g status-justify centre
      set -g status-style "bg=default,fg=white"

      set -g status-left-length 50
      set -g status-right-length 50
      set -g status-right '#[fg=brightblack,bg=default]#[fg=white,bg=brightblack]󱑂 %H:%M #[fg=brightblack,bg=default] '

      # Left status: Session pill (gray by default, white when prefix is active)
      set -g status-left '  #[fg=${sessionColor},bg=default]#[fg=${black},bold,bg=${sessionColor}] #S#[fg=${sessionColor},bg=default]'

      # Window status: Inactive subdued pills & Active rotating color pills (16 ANSI colors)
      set -g window-status-separator "  "
      set -g window-status-format '#[fg=brightblack,bg=default]#[fg=${black},bg=brightblack]#I #[fg=brightblack,bg=default]#[fg=${black},bg=brightblack] #W#{?window_flags, #{window_flags},}#[fg=brightblack,bg=default]'

      set -g window-status-current-format '#[fg=${windowColor},bg=default]#[fg=${black},bg=${windowColor}]#I #[fg=${windowColor},bg=default]#[fg=${black},bg=white] #W#{?window_flags, #{window_flags},}#[fg=white,bg=default]'

      # Pane borders
      set -g pane-border-style "fg=brightblack,bg=default"
      set -g pane-active-border-style "fg=cyan,bg=default"
    '';
  };
}
