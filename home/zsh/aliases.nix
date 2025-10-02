{
  zshconfig = "code ~/.zshrc";

  l = "eza -lah";
  lg = "eza -lah --git";

  v = "nvim . && clear";

  c = "clear ; tmux clear-history ; clear";

  j = "z";

  did = "vim +'normal Go' +'r!date' ~/did.txt";

  # use nvim, but don't make me think about it
  vim = "nvim";

  # Filesystem aliases
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";

  # IP addresses
  my_ip = "dig +short myip.opendns.com @resolver1.opendns.com";
  localip = "ipconfig getifaddr en1";
  ips = "ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'";

  # Flush Directory Service cache
  flush = "sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder";

  # Hide/show all desktop icons (useful when presenting)
  hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
  showdesktop = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";

  # Brew
  buc = "brew upgrade && brew cleanup";

  # Cargo
  cb = "cargo build";
  ct = "cargo test";
  cr = "cargo run";
  ctn = "cargo test -- --nocapture";
  cwc = "cargo watch -c -x 'check'";
  cwct = "cargo watch -c -x 'check' -x 'test -- --nocapture'";
  cwctr = "cargo watch -c -x 'check' -x 'test -- --nocapture' -x 'run'";

  # Git
  gpl = "git pull";
  gps = "git push";
  gpr = "git push && gh pr create --fill --web";
  gb = "git checkout -b";
  ghv = "gh repo view --web";
  gm = "git checkout master || git checkout main";
  gst = "git status";

  # JJ
  jr = "jj rebase -d master";
  jp = "jj log --no-pager";
  jst = "jj st --no-pager";
  jd = "jj diff --tool=difft";

  # tmuxp
  tl = "tmuxp load --yes";

  # Restarts coreaudio, use when headphones don't work
  fix_audio = "sudo pkill coreaudiod";

  # Docker-compose alias
  dc = "docker-compose";
  dcu = "docker-compose up";
  dcd = "docker-compose down";

  # K8s
  k8 = "kubectl";
  km = "kubectl -n master";

  news = "w3m https://news.ycombinator.com";
}
