---
title: "Backup Files"
date: 2021-12-08T11:08:32+08:00
draft: false
tags: 
    - "Tools"
    - "Script"
categories :                             
    - "Script"
    - "Documents"
keywords :                                 
    - "tools"
    - "script"

#menu: footer # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "Backup Files" # Lead text
comments: false # Enable Disqus comments for specific page
authorbox: true # Enable authorbox for specific page
pager: true # Enable pager navigation (prev/next) for specific page
toc: true 
mathjax: false # Enable MathJax for specific page
sidebar: "right" # Enable sidebar (on the right side) per page
widgets: # Enable sidebar widgets in given order per page
  - "search"
  - "recent"
  - "taglist"
---

```powershell
$log_file_path="D:\log\info_"+ (Get-Date -Format "yyyy-MM-dd") + ".log"
$error_log_file = "D:\log\error_"+ (Get-Date -Format "yyyy-MM-dd") + ".log"


$tar_dir_list=@("D:\DailyBackup\KIS_JD", "D:\DailyBackup\KIS_YP")

foreach($tar_dir in $tar_dir_list){
    $file_list = get_file_list($tar_dir)

    cacl_sha256($file_list)
}



function write_log_file($message)
{
    (Get-Date).ToString() +" - "+  $message  >> $log_file_path
}
function write_error_log($message)
{
    (Get-Date).ToString() +" - "+  $message  >> $error_log_file
}


function get_file_list($dir_path, $exclude_extension = '.sha256')
{
    write_log_file("begin check files under ${dir_path}")
    $result = @()
    $file_list=(get-childitem $dir_path)
    Foreach($file_item in $file_list){
        if ($file_item.Extension -ne $exclude_extension)
        {
        $result +=@($file_item)
        }
    }
    return $result
}

function cacl_sha256($file_list)
{
    Foreach($file_item in $file_list)
    {
        $full_name = $file_item.FullName
        $sha_file=(-Join( $full_name, ".sha256"))
        $sha_value = (CertUtil  -hashfile $full_name sha256)[1]
        $expect_sha = (-Join((CertUtil  -hashfile $full_name sha256)[1], "    ", $file_item.Name))
        if(Test-Path $sha_file)
        {
            
            if($expect_sha  -ne (Get-Content $sha_file)){
                
                write_error_log((-Join( "file: ${full_name}", [Environment]::NewLine, "expect value: ${expect_sha}", [Environment]::NewLine, "actual value: " + (Get-Content $sha_file))))
                write_log_file("File ${sha_file} Exist but Not Match")
            }
            else {
                write_log_file("File ${sha_file} Exist and Match")
            }
            
        }
        else {
            $expect_sha > $sha_file
        }
    }
}



```