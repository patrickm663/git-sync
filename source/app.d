import std.algorithm;
import std.array;
import std.conv;
import std.process;
import std.stdio;
import std.string;

void main(string [] args) {
  "Searching for Git repos...".writeln;
  // By default, exclude hidden folders
  auto res = executeShell("find ~/* -path '*.git' 2>/dev/null");
  if (res.status != 0) "No Git repos found".writeln; 
  else {
    string [] lines = res.output.split("\n").array;
    // Subtract 1 because of empty string at end
    string reposLength = (lines.length - 1).to!string;
    string reposFound = "Repos Found: " ~ reposLength;
    reposFound.writeln;

    string [] reposOutdated; 
    string progress;
    int count = 0;

    foreach(line; lines) {
      if (line != "") {
        count += 1;
        progress = "[" ~ count.to!string ~ "/" ~ reposLength ~ "] " ~ line; 
        progress.writeln;
        if (getPullStatus(line)) {
          reposOutdated ~= line;
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
      string response = "";
      while (response != "y") {
	"Would you like to update? [Y/n]".writeln;
	response = readln().toLower.strip("\n");
	if (response == "y") {
	  "Updates in progress...".writeln;
	  gitPull(reposOutdated);
	} else if (response == "n") {
	  "Exiting... Bye!".writeln;
	  break;
	} else {
	  "Invalid response!".writeln;
	}
      }
    }
  }
}

bool getPullStatus(string d) {
  string enterDir = "cd " ~ d ~ " && cd ../";
  string checkStatus = enterDir ~ " && git remote update; git status -uno 2>/dev/null";
  auto r = executeShell(checkStatus).output;
  // If the output *is not* 'Your branch is up to date...', contain 'ahead'/'behind', or doesn't have a remote, return true and proceed to track the directories as out-of-date. Else, skip
  if (indexOf(r, "Your branch is up to date") == -1 && indexOf(r, "ahead") == -1 && indexOf(r, "behind") == -1 && indexOf(r, "No commits yet") == -1 && indexOf(r, "origin") != -1) {
    return true;
  }
  return false;
}

void gitPull(string [] d) {
  int count = 0;
  string repos = d.length.to!string;
  string message;
  foreach(f; d) {
    count = count + 1;
    message = "[" ~ count.to!string ~ "/" ~  repos ~ "] " ~ f; 
    message.writeln;

    string enterDir = "cd " ~ f ~ " && cd ../";
    string pull = enterDir ~ " && git pull"; 
    auto gp = executeShell(pull);
    gp.output.writeln;
  }
  "Complete!".writeln;
}
