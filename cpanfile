requires "Exporter" => "0";
requires "Moo" => "1.006000";
requires "Pod::Checker" => "0";
requires "Pod::Coverage" => "0";
requires "Test::More" => "0";
requires "Test::Pod::Coverage" => "0";
requires "WebService::Client" => "0.0001";
requires "base" => "0";
requires "constant" => "0";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::More" => "0";
  requires "perl" => "5.006";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Test::Pod" => "1.41";
};
