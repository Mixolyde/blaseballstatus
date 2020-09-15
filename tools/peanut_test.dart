import 'dart:io';

import 'package:git/git.dart';
import 'package:path/path.dart' as p;

String workingDir = p.current;

Future<void> main(List<String> args) async {

  print(workingDir);
  
  final isGitDir = await GitDir.isGitDir(workingDir);

  if (!isGitDir) {
    print('Not a git directory: $workingDir');
  }

  final gitDir = await GitDir.fromExisting(workingDir, allowSubdirectory: true);
  
  print(gitDir);
  
  var pr = await runCommand(
    const ['rev-parse', '--verify', '--symbolic-full-name', 'HEAD']);
  print(pr.stdout as String);
  pr = await runCommand(
    ['show-ref', '--verify', (pr.stdout as String).trim()]);
  print(pr.stdout as String);
  
  print(CommitReference.fromShowRefOutput(pr.stdout as String));
  // current branch cannot be targetBranch
  final currentBranch = await gitDir.currentBranch();

  print(currentBranch);
  
}

Future<ProcessResult> runCommand(List<String> args) async {
  return await Process.run('git', args,
      workingDirectory: workingDir, runInShell: true);
  
}