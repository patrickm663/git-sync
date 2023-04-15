import std.algorithm;
import std.array;
import std.conv;
import std.process;
import std.stdio;
import std.string;

void main() {
  "Searching for Git repos...".writeln;
  auto res = executeShell("find ~/ -name '.git' 2>/dev/null");
  if (res.status == 0) "No Git repos found".writeln; 
  else {
    string [] lines = res.output.split("\n").array;
    // Subtract 1 because of empty string at end
    string reposLength = (lines.length - 1).to!string;
    string reposFound = "Repos Found: " ~ reposLength;
    reposFound.writeln;

    string [] reposOutdated; 
    string progress;
    string g;
    int count = 0;

    foreach(line; lines) {
      if (line != "") {
	count += 1;
	progress = "[" ~ count.to!string ~ "/" ~ reposLength ~ "] " ~ line; 
	progress.writeln;
	g = getPullStatus(line);
	if (g != "NULL") {
	  reposOutdated ~= g;
	}
      }
    }
    if (reposOutdated.length == 0) {
      "All repos up-to-date".writeln;
    } else {
      string reposFoundOutOfDate = "Out-of-date Repos Found: " ~ reposOutdated.length.to!string;
      reposFoundOutOfDate.writeln;
      "The following repos are out-of-date: ".writeln;
      reposOutdated.join("\n").writeln;
      "Would you like to update? [Y/n]".writeln;
      string response = readln().toLower.strip("\n");
      if (response == "y") {
	gitPull(reposOutdated);
      } else {
	"Exiting".writeln;
      }
    }
  }
}

string getPullStatus(string d) {
  string enterDir = "cd " ~ d ~ " && cd ../";
  string checkStatus = enterDir ~ " && git remote update; git status -uno 2>/dev/null";
  auto r = executeShell(checkStatus).output;
  if (indexOf(r, "Your branch is up to date") == -1) {
    d.writeln;
    return d;
  }
  return "NULL";
}

void gitPull(string [] d) {
 foreach(f; d) {
  string enterDir = "cd " ~ f ~ " && cd ../";
  string pull = enterDir ~ " && git pull"; 
  executeShell(pull);
 } 
 "Complete!".writeln;
}
