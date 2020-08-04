requires "Exporter";
requires "Pod::Checker";
requires "Pod::Coverage";
requires "Test::More";
requires "Test::Pod::Coverage";
requires "constant";

on 'test' => sub {
    requires "File::Spec";
    requires "IO::Handle";
    requires "IPC::Open3";
    requires "Test::More", ">= 0.98";
};

on 'configure' => sub {
    requires "ExtUtils::MakeMaker";
};

on 'develop' => sub {
    requires "Test::Pod", "1.41";
};
