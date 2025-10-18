on open theFiles
    repeat with aFile in theFiles
        set filePath to POSIX path of aFile
        do shell script "open -na Ghostty.app --args -e /bin/zsh -l -c \"/opt/homebrew/bin/nvim '" & filePath & "'\""
    end repeat
end open
