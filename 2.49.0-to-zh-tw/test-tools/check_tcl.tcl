# -*- coding: utf-8 -*-
proc check_brackets {filename} {
    set f [open $filename r]
    fconfigure $f -encoding utf-8
    set content [read $f]
    close $f

    set line_num 1
    set brace_count 0  ;# ��A���p�ƾ� { }
    set paren_count 0  ;# ��A���p�ƾ� ( )
    set error_lines [list]  ;# �O���i�঳���D����

    # �v���ˬd�A���ǰt
    foreach line [split $content \n] {
        # ���������M�r�Ŧ�A�קK�z�Z�˴�
        set clean_line [regsub -all {#.*$} $line ""]
        set clean_line [regsub -all {\"[^\"]*\"} $clean_line ""]
        set clean_line [regsub -all {'[^']*'} $clean_line ""]

        # �έp��e�檺�A���ƶq
        set open_braces [llength [regexp -all -inline {\{} $clean_line]]
        set close_braces [llength [regexp -all -inline {\}} $clean_line]]
        set open_parens [llength [regexp -all -inline "\\(" $clean_line]]
        set close_parens [llength [regexp -all -inline "\\)" $clean_line]]

        # ��s�`�p�ƾ�
        incr brace_count [expr {$open_braces - $close_braces}]
        incr paren_count [expr {$open_parens - $close_parens}]

        # �O���i�঳���D����]�A�������š^
        if {$open_braces != $close_braces || $open_parens != $close_parens} {
            lappend error_lines [list $line_num $line]
        }

        incr line_num
    }

    # ��X���G
    puts "�A���έp���G�G"
    puts "��A���G���`��-[expr {$brace_count > 0 ? $brace_count : 0}] �k�`��-[expr {$brace_count < 0 ? abs($brace_count) : 0}]"
    puts "��A���G���`��-[expr {$paren_count > 0 ? $paren_count : 0}] �k�`��-[expr {$paren_count < 0 ? abs($paren_count) : 0}]"

    if {$brace_count != 0 || $paren_count != 0} {
        puts "? �A�����ǰt"
        if {[llength $error_lines] > 0} {
            puts "\n�i�঳���D����G"
            foreach {num text} $error_lines {
                puts "�渹 $num: [string range $text 0 70]..."  ;# ��ܫe70�Ӧr��
            }
        }
    } else {
        puts "? �A���ǰt���`"
    }
}

# �ե��˴�
check_brackets "C:/Program Files/Git/mingw64/lib/tk8.6/console.tcl"