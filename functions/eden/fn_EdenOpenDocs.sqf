/*
    OKS_fnc_EdenOpenDocs

    Opens a Functions Viewer and copies a function name to the clipboard.

    Prefers the 3DEN Enhanced Functions Viewer (if the mod is loaded), otherwise falls
    back to the vanilla Arma 3 Functions Viewer.

    Usage:
      ["OKS_fnc_Lambs_Wavespawn"] call OKS_fnc_EdenOpenDocs;

    Notes:
      - Best-effort: opens Functions Viewer and attempts to fill the search box.
      - Always copies the function name to clipboard as a fallback.
*/

params ["_functionName", ["_openUI", true, [true]]];

if !(_functionName isEqualType "") exitWith {
  "Open Docs: function name must be a string." call OKS_fnc_LogDebug;
  ["Open Docs: invalid function name", 1, 5, true] call BIS_fnc_3DENNotification;
};

// 3DEN Enhanced search works better with the short function name (without OKS_fnc_ prefix).
private _searchTerm = _functionName;
private _idx = (toLower _searchTerm) find "_fnc_";
if (_idx > -1) then {
  private _len = count _searchTerm;
  _searchTerm = _searchTerm select [_idx + 5, _len];
};
_searchTerm = toUpper _searchTerm;

copyToClipboard _searchTerm;
[format ["Open Function: %1 (search '%2' copied)", _functionName, _searchTerm], 0, 4, true] call BIS_fnc_3DENNotification;

if (_openUI) then {
  [_functionName, _searchTerm] spawn {
    params ["_fn", "_term"];
    disableSerialization;

    scopeName "OKS_EdenOpenDocs";

    // Prefer 3DEN Enhanced Functions Viewer if available.
    // It exposes the display handle via uiNamespace (idd is -1).
    private _has3DENEnhanced =
      isClass (configFile >> "CfgPatches" >> "3denEnhanced") ||
      isClass (configFile >> "CfgPatches" >> "enhanced_3den");
    private _disp3DEN = findDisplay 313; // IDD_DISPLAY3DEN
    if (_has3DENEnhanced && {!isNull _disp3DEN}) then {
      private _enhDisp = uiNamespace getVariable ["ENH_Display_FunctionsViewer", displayNull];
      if (isNull _enhDisp) then {
        _disp3DEN createDisplay "ENH_FunctionsViewer";
      };

      private _timeoutEnh = time + 2;
      waitUntil {
        uiSleep 0.01;
        _enhDisp = uiNamespace getVariable ["ENH_Display_FunctionsViewer", displayNull];
        (!isNull _enhDisp) || {time > _timeoutEnh}
      };

      if (!isNull _enhDisp) then {
        // ENH restores prior UI state shortly after opening; wait a tick.
        uiSleep 0.05;
        private _ctrlSearch = _enhDisp displayCtrl 1400;
        if (!isNull _ctrlSearch) then {
          _ctrlSearch ctrlSetText _term;
        };

        // Try to auto-select the first matching function entry so the code pane updates.
        uiSleep 0.10;
        private _controlsEnh = allControls _enhDisp;

        // Prefer a tree control (ENH groups functions hierarchically).
        private _tree = controlNull;
        {
          if ((ctrlType _x) == 12) exitWith { _tree = _x; };
        } forEach _controlsEnh;

        private _termLower = toLower _term;

        if (!isNull _tree) then {
          private _scoreText = {
            params ["_textLower", "_termLower", "_isLeaf"];
            private _idx = _textLower find _termLower;
            if (_idx < 0) exitWith {-1};

            private _score = 300 + _idx;
            if (_textLower isEqualTo _termLower) then {
              _score = 0;
            } else {
              if (_idx isEqualTo 0) then {
                _score = 50;
              } else {
                if ((_idx + (count _termLower)) isEqualTo (count _textLower)) then {
                  _score = 100;
                };
              };
            };

            // Prefer leaf nodes (actual functions) over category/group nodes.
            if (!_isLeaf) then {
              _score = _score + 10000;
            };

            _score
          };

          private _scanBest = {
            params ["_tree", "_termLower", "_path", "_scoreFn", "_scanFn"];
            private _best = [1e9, []];

            private _textLower = toLower (_tree tvText _path);
            private _isLeaf = (_tree tvCount _path) isEqualTo 0;
            private _score = [_textLower, _termLower, _isLeaf] call _scoreFn;
            if (_score > -1 && {_score < (_best select 0)}) then {
              _best = [_score, _path];
            };

            private _childCount = _tree tvCount _path;
            for "_i" from 0 to (_childCount - 1) do {
              private _res = [_tree, _termLower, _path + [_i], _scoreFn, _scanFn] call _scanFn;
              if ((_res select 0) < (_best select 0)) then {
                _best = _res;
              };
            };

            _best
          };

          private _best = [1e9, []];
          private _rootCount = _tree tvCount [];
          for "_r" from 0 to (_rootCount - 1) do {
            private _res = [_tree, _termLower, [_r], _scoreText, _scanBest] call _scanBest;
            if ((_res select 0) < (_best select 0)) then {
              _best = _res;
            };
          };

          private _matchPath = _best select 1;

          // Fallback: pick the first leaf item.
          if (_matchPath isEqualTo []) then {
            if (_rootCount > 0) then {
              _matchPath = [0];
              while {(_tree tvCount _matchPath) > 0} do {
                _matchPath pushBack 0;
              };
            };
          };

          if !(_matchPath isEqualTo []) then {
            _tree tvSetCurSel _matchPath;
          };
        } else {
          // Some UIs use a listbox/listNbox instead of a tree; try to select first match.
          private _lb = controlNull;
          {
            private _ct = ctrlType _x;
            if (_ct == 5 || {_ct == 102}) exitWith { _lb = _x; };
          } forEach _controlsEnh;

          if (!isNull _lb) then {
            private _size = lbSize _lb;
            private _bestIdx = -1;
            private _bestScore = 1e9;
            for "_i" from 0 to (_size - 1) do {
              private _t = toLower (_lb lbText _i);
              private _idx = _t find _termLower;
              if (_idx > -1) then {
                private _score = 300 + _idx;
                if (_t isEqualTo _termLower) then {
                  _score = 0;
                } else {
                  if (_idx isEqualTo 0) then {
                    _score = 50;
                  } else {
                    if ((_idx + (count _termLower)) isEqualTo (count _t)) then {
                      _score = 100;
                    };
                  };
                };
                if (_score < _bestScore) then {
                  _bestScore = _score;
                  _bestIdx = _i;
                };
              };
            };
            if (_bestIdx < 0 && {_size > 0}) then { _bestIdx = 0; };
            if (_bestIdx > -1) then { _lb lbSetCurSel _bestIdx; };
          };
        };

        breakOut "OKS_EdenOpenDocs";
      };
    };

    // Vanilla Functions Viewer fallback.
    // Best-effort: open the Functions Viewer. If it's already open, this is harmless.
    createDialog "RscDisplayFunctionsViewer";

    // Try common IDDs for the Functions Viewer.
    private _idds = [2929, 2928];
    private _disp = displayNull;
    private _timeout = time + 2;
    waitUntil {
      {
        _disp = findDisplay _x;
        if (!isNull _disp) exitWith {true};
      } forEach _idds;
      (!isNull _disp) || {time > _timeout}
    };

    if (isNull _disp) exitWith {};

    // Find an edit control (search box) and set text.
    // CT_EDIT is 2, but we keep it loose: pick the first empty edit control.
    private _controls = allControls _disp;
    {
      private _ct = ctrlType _x;
      if (_ct == 2) then {
        if ((ctrlText _x) isEqualTo "") exitWith {
          _x ctrlSetText _term;
        };
      };
    } forEach _controls;
  };
};
