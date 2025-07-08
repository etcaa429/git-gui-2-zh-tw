# -*- coding: utf-8 -*-
proc check_brackets {filename} {
    set f [open $filename r]
    fconfigure $f -encoding utf-8
    set content [read $f]
    close $f

    set line_num 1
    set brace_count 0  ;# 花括號計數器 { }
    set paren_count 0  ;# 圓括號計數器 ( )
    set error_lines [list]  ;# 記錄可能有問題的行

    # 逐行檢查括號匹配
    foreach line [split $content \n] {
        # 移除註釋和字符串，避免干擾檢測
        set clean_line [regsub -all {#.*$} $line ""]
        set clean_line [regsub -all {\"[^\"]*\"} $clean_line ""]
        set clean_line [regsub -all {'[^']*'} $clean_line ""]

        # 統計當前行的括號數量
        set open_braces [llength [regexp -all -inline \{ $clean_line]]
        set close_braces [llength [regexp -all -inline \} $clean_line]]
        set open_parens [llength [regexp -all -inline {\\(} $clean_line]]
        set close_parens [llength [regexp -all -inline {\\)} $clean_line]]

        # 更新總計數器
        incr brace_count [expr {$open_braces - $close_braces}]
        incr paren_count [expr {$open_parens - $close_parens}]

        # 記錄可能有問題的行（括號不平衡）
        if {$open_braces != $close_braces || $open_parens != $close_parens} {
            lappend error_lines [list $line_num $line]
        }

        incr line_num
    }

    # 輸出結果
    puts "括號統計結果："
    puts "花括號：左總數-[expr {$brace_count > 0 ? $brace_count : 0}] 右總數-[expr {$brace_count < 0 ? abs($brace_count) : 0}]"
    puts "圓括號：左總數-[expr {$paren_count > 0 ? $paren_count : 0}] 右總數-[expr {$paren_count < 0 ? abs($paren_count) : 0}]"

    if {$brace_count != 0 || $paren_count != 0} {
        puts "❌ 括號不匹配"
        if {[llength $error_lines] > 0} {
            puts "\n可能有問題的行："
            foreach {num text} $error_lines {
                puts "行號 $num: [string range $text 0 70]..."  ;# 顯示前70個字符
            }
        }
    } else {
        puts "✅ 括號匹配正常"
    }
}

# 調用檢測
check_brackets "C:/Program Files/Git/mingw64/lib/tk8.6/console.tcl"
