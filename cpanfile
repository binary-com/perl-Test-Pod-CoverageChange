requires "Exporter" => "0";
requires "Pod::Checker" => "0";
requires "Pod::Coverage" => "0";
requires "Test::More" => "0";
requires "Test::Pod::Coverage" => "0";
requires "constant" => "0";

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
