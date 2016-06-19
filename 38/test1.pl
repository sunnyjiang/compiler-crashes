#!/usr/bin/perl
use IPC::Run3;
use BSD::Resource;
setrlimit(RLIMIT_CPU, 60, 60);
setrlimit(RLIMIT_FSIZE, 1*1000*1000*1000, 1*1000*1000*1000);
setrlimit(RLIMIT_AS, 6*1000*1000*1000, 6*1000*1000*1000);
setrlimit(RLIMIT_VMEM, 6*1000*1000*1000, 6*1000*1000*1000);
system "g++ -o /dev/null -g -O2 -Wformat -Werror=format-security -pthread -fPIC -mtune=native  -c small.cpp >/dev/null 2>&1";
exit (-1) unless ($? == 0);
system "/home/regehr/z/compiler-install/llvm-r237728-install/bin/clang++ -o /dev/null -O2 -fstack-protector --param=ssp-buffer-size=4 -O3  -c small.cpp >/dev/null 2>&1";
exit (-1) unless ($? == 0);
my $str = <<EOF;
Assertion `D && "Cannot get layout of forward declarations!"' failed.
EOF
chomp $str;
system "rm -f out.txt";
my $err;
my $cmd = "/home/regehr/z/compiler-install/llvm-r110244-install/bin/clang++ -g small.cpp ";
IPC::Run3::run3 ($cmd, \undef, \$err, \$err);
my $idx = index($err,$str);
exit (-1) if ($idx == -1);
exit (0);
