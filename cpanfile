requires "Test::More" => "1.302175";
requires "Pod::Coverage" => "0.23";
requires "Test::Pod::Coverage" => "1.10";
requires "Pod::Checker" => "1.73";

on 'test' => sub {
  requires "Exporter" => "0";
  requires "File::Spec" => "0";
  requires "Test::More" => "1.302175";
  requires "perl" => "5.006";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Test::Pod" => "1.41";
};
