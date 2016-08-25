# Clipboard methods
def clipr
  IO.popen('xclip -o', 'r').read
end

def clipw(element)
  IO.popen('xclip -sel clip', 'w') {|io| io.print(element)}
end
