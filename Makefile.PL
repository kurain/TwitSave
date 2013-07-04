use inc::Module::Install;

name 'TwitSave';
version '0.00';

requires 'AnyEvent::Twitter::Stream';
requires 'Encode';
requires 'FindBin::libs';
requires 'Config::Pit';
requires 'DBI';

WriteAll;

