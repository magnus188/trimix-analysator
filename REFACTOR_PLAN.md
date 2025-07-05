# Trimix Codebase Refactoring Plan

## Priority 1: Settings Management Cleanup

### Current Issues
- Two competing settings systems (JSON vs SQLite)
- `settings_manager.py` is still imported but not used
- `settings_adapter.py` wraps database calls unnecessarily
- Default settings duplicated in 3 places

### Recommended Solution
1. **Remove `utils/settings_manager.py`** entirely
2. **Simplify `utils/settings_adapter.py`** to just re-export `db_manager` functions
3. **Consolidate default settings** into `database_manager.py` only
4. **Update all imports** to use database manager directly

### Migration Steps
1. Remove unused imports of `settings_manager`
2. Replace `settings_manager` calls with `db_manager` calls
3. Delete `settings_manager.py`
4. Simplify `settings_adapter.py`

## Priority 2: KV File Loading Optimization

### Current Issues
- Manual KV file loading in main.py (11 files)
- No error handling for missing KV files
- Hardcoded file paths

### Recommended Solution
- Auto-discovery and loading of KV files
- Centralized KV loading with error handling
- Convention-based KV file organization

## Priority 3: Import Optimization

### Current Issues
- All screen classes imported in main.py even if not immediately used
- Heavy imports at startup
- Circular dependency risks

### Recommended Solution
- Lazy loading of screen classes
- Plugin-style architecture for screens
- Lighter main.py startup

## Priority 4: Error Handling

### Current Issues
- Silent failures in many places (pass statements)
- No logging for errors
- No user feedback for failures

### Recommended Solution
- Proper error logging
- User-friendly error messages
- Graceful degradation

## Priority 5: Code Duplication

### Current Issues
- Default settings duplicated
- Similar screen patterns repeated
- Navigation code duplicated

### Recommended Solution
- Base screen classes
- Shared navigation mixins
- Configuration-driven screens
