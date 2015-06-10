//
program AoikWinWhich;

uses
  Classes,
  SysUtils,
  strutils;

  function StringSplit(str: string; delim: char): TStringList;
  begin
    Result := TStringList.Create;
    Result.StrictDelimiter := True;
    Result.Delimiter := delim;
    Result.DelimitedText := str;
  end;

  function StringListUniq(item_s: TStringList): TStringList;
  var
    i: integer;
    item: string;
  begin
    Result := TStringList.Create;

    for i := 0 to item_s.Count - 1 do
    begin
      item := item_s[i];

      if Result.IndexOf(item) = -1 then
        Result.add(item);
    end;
  end;

  function FindExePaths(prog: string): TStringList;
  var
    env_pathext: string;
    i: integer;
    ext: string;
    ext_s: TStringList;
    ext_s_2: TStringList;
    env_path: string;
    dir_path: string;
    dir_path_s: TStringList;
    prog_lc: string;
    prog_has_ext: boolean;
    exe_path_s: TStringList;
    path: string;
    path2: string;
  begin
    // 8f1kRCu
    env_pathext := GetEnvironmentVariable('PATHEXT');

    // 4fpQ2RB
    if env_pathext = '' then
       // 9dqlPRg
       exit();

    // 6qhHTHF
    // Split into a list of extensions
    ext_s := StringSplit(env_pathext, ';');

    //
    ext_s_2 := TStringList.Create;

    for i := 0 to ext_s.Count - 1 do
    begin
      ext := ext_s[i];

      // 2pGJrMW
      // Strip
      ext := Trim(ext);

      // 2gqeHHl
      // Remove empty.
      // Must be done after the stripping at 2pGJrMW.
      if ext <> '' then
      begin
        // 2zdGM8W
        // Convert to lowercase
        ext := LowerCase(ext);

        ext_s_2.add(ext);
      end;

      // 2fT8aRB
      // Uniquify
      ext_s_2 := StringListUniq(ext_s_2);

      // 4ysaQVN
      env_path := GetEnvironmentVariable('PATH');

      // 5gGwKZL
      if env_path = '' then
        // 7bVmOKe
        // Go ahead with "dir_path_s" being empty
        dir_path_s := TStringList.Create
      else
        // 6mPI0lg
        // Split into a list of paths
        dir_path_s := StringSplit(env_path, ';');

      // 5rT49zI
      // Insert empty dir path to the beginning.
      //
      // Empty dir handles the case that "prog" is a path, either relative or
      //  absolute. See code 7rO7NIN.
      dir_path_s.Insert(0, '');

      // 2klTv20
      // Uniquify
      dir_path_s := StringListUniq(dir_path_s);

      // 9gTU1rI
      // Check if "prog" ends with one of the file extension in "ext_s".
      //
      // "ext_s_2" are all in lowercase, ensured at 2zdGM8W.
      prog_lc := LowerCase(prog);

      prog_has_ext := False;

      for ext in ext_s_2 do
        if AnsiEndsStr(ext, prog_lc) then
        begin
          prog_has_ext := True;

          break;
        end;

      // 6bFwhbv
      exe_path_s := TStringList.Create;

      for dir_path in dir_path_s do
      begin
        // 7rO7NIN
        // Synthesize a path
        if dir_path = '' then
          path := prog
        else
          path := dir_path + '\' + prog;

        // 6kZa5cq
        // If "prog" ends with executable file extension
        if prog_has_ext then
        begin
          // 3whKebE
          if FileExists(path) then
            // 2ffmxRF
            exe_path_s.add(path);
        end;

        // 2sJhhEV
        // Assume user has omitted the file extension
        for ext in ext_s_2 do
        begin
          // 6k9X6GP
          // Synthesize a path with one of the file extensions in PATHEXT
          path2 := path + ext;

          // 6kabzQg
          if FileExists(path2) then
             // 7dui4cD
             exe_path_s.add(path2);
        end;
      end;
    end;

    // 8swW6Av
    // Uniquify
    exe_path_s := StringListUniq(exe_path_s);

    // 7y3JlnS
    Result := exe_path_s;
  end;

  function Main: integer;
  var
    usage: string;
    prog: string;
    exe_path_s: TStringList;
    i: integer;
  begin
    // 9mlJlKg
    // If not exactly one command argument is given
    if ParamCount <> 1 then
    begin
      // 7rOUXFo
      // Print program usage
      usage :=
        'Usage: aoikwinwhich PROG'#10 +
        #10 +
        '#/ PROG can be either name or path'#10 +
        'aoikwinwhich notepad.exe'#10 +
        'aoikwinwhich C:\Windows\notepad.exe'#10 +
        #10 +
        '#/ PROG can be either absolute or relative'#10 +
        'aoikwinwhich C:\Windows\notepad.exe'#10 +
        'aoikwinwhich Windows\notepad.exe'#10 +
        #10 +
        '#/ PROG can be either with or without extension'#10 +
        'aoikwinwhich notepad.exe'#10 +
        'aoikwinwhich notepad'#10 +
        'aoikwinwhich C:\Windows\notepad.exe'#10 +
        'aoikwinwhich C:\Windows\notepad';

      Writeln(usage);

      // 3nqHnP7
      exit(1);
    end;

    // 9m5B08H
    // Get executable name or path
    prog := ParamStr(1);

    // 8ulvPXM
    // Find executable paths
    exe_path_s := FindExePaths(prog);

    // 5fWrcaF
    // If has found none
    if exe_path_s.Count = 0 then
    begin
      // 3uswpx0
      exit(2);
    end
    // If has found some
    else
    begin
      // 9xPCWuS
      // Print result
      for i := 0 to exe_path_s.Count - 1 do
        Writeln(exe_path_s[i]);

      // 4s1yY1b
      exit(0);
    end;
  end;

begin
  // 4zKrqsC
  // Program entry
  exitcode := Main;
end.
