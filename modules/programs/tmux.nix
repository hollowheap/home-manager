{ config, pkgs, lib, ... }:

let
  pills = config.styles.pills.tmux;

  colors = [
    "cyan"
    "blue"
    "magenta"
    "green"
    "yellow"
    "red"
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
  modeText = "#{?client_prefix,PREFIX,#{?pane_in_mode,COPY,NORMAL}}";
  modeColor = "#{?client_prefix,yellow,#{?pane_in_mode,magenta,blue}}";

  batteryBin = "${pkgs.tmux-battery}/bin/tmux-battery";
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
        plugin = smart-splits;
        extraConfig = ''
          set -g @smart-splits_no_wrap \'\' # to disable wrapping. (any value disables wrapping)

          set -g @smart-splits_move_left_key  'C-h' # key-mapping for navigation with Alt
          set -g @smart-splits_move_down_key  'C-j' #  --"--
          set -g @smart-splits_move_up_key    'C-k' #  --"--
          set -g @smart-splits_move_right_key 'C-l' #  --"--

          set -g @smart-splits_resize_left_key  'M-h' # key-mapping for resizing with Ctrl
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

      set -as terminal-features ",*:RGB"
      set -ga terminal-overrides ",*:Tc"

      set -g set-clipboard on
      set -g allow-passthrough on
      set -g status-interval 1

      # Passthrough escape fallbacks
      bind C-Space send-prefix
      bind C-h send-keys C-h
      bind C-j send-keys C-j
      bind C-k send-keys C-k
      bind C-l send-keys C-l

      bind x kill-pane
      bind X kill-window
      bind B break-pane

      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Window navigation
      bind c new-window -c "#{pane_current_path}"
      bind Tab last-window
      bind -r C-p previous-window
      bind -r p previous-window
      bind -r C-n next-window
      bind -r n next-window

      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # Splits & Layout equalizers (Shift key symmetry)
      unbind %
      bind \\ split-window -h -c "#{pane_current_path}"

      unbind \"
      bind - split-window -v -c "#{pane_current_path}"

      bind | select-layout even-horizontal
      bind _ select-layout even-vertical
      bind = select-layout tiled

      bind -r M-j resize-pane -D 5
      bind -r M-k resize-pane -U 5
      bind -r M-h resize-pane -L 5
      bind -r M-l resize-pane -R 5

      bind -r m resize-pane -Z

      set -g mode-keys vi
      set -g status-keys vi

      unbind v
      bind v copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi Escape send -X cancel
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "wl-copy"

      bind y display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "yazi"
      bind C-y display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "yazi"
      bind g display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "lazygit"
      bind C-g display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "lazygit"
      bind t display-popup -d "#{pane_current_path}" -w 85% -h 80% -E "$SHELL"
      bind C-t display-popup -d "#{pane_current_path}" -w 85% -h 80% -E "$SHELL"
      bind b display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "btop"
      bind C-b display-popup -d "#{pane_current_path}" -w 90% -h 90% -E "btop"

      # Status bar configuration
      set -g status-position top
      set -g status-justify centre
      set -g status-style "bg=default,fg=brightwhite"

      set -g status-left-length 80
      set -g status-right-length 80
      set -g status-right '${pills.right { text = "%d %b"; icon = "󰃭"; accent = "blue"; }}  ${pills.right { text = "%H:%M"; icon = "󱑂"; accent = "magenta"; }} '

      # Left status: Mode pill at left-most, followed by Session pill and Battery pill
      set -g status-left ' ${pills.mode { text = modeText; color = modeColor; }}  ${pills.left { icon = ""; text = "#S"; accent = modeColor; boldIcon = true; }}#{?#(${batteryBin} pct),  ${pills.left { icon = "#(${batteryBin} icon)"; text = "#(${batteryBin} pct)%"; accent = "#(${batteryBin} color)"; iconFg = "white"; }},}'

      # Window status: Rotating color pills across all windows; active window distinguished with illuminated body
      set -g window-status-separator "  "
      set -g window-status-format '${pills.left { icon = "#I"; text = "#W#{?window_flags, #{window_flags},}"; accent = windowColor; }}'

      set -g window-status-current-format '${pills.left { icon = "#I"; text = "#W#{?window_flags, #{window_flags},}"; accent = windowColor; charcoal = "white"; charcoalFg = "black"; boldText = true; boldIcon = true; }}'

      # Pane borders
      set -g pane-border-style "fg=brightblack,bg=default"
      set -g pane-active-border-style "fg=cyan,bg=default"
    '';
  };

  home.activation.tmuxReload = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ${pkgs.tmux}/bin/tmux info >/dev/null 2>&1; then
      ${pkgs.tmux}/bin/tmux source-file ~/.config/tmux/tmux.conf >/dev/null 2>&1 || true
    fi
  '';
}
