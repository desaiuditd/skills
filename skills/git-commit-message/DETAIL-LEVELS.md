# Detail Level Guidelines

Match the depth of the body to the complexity of the change, where complexity is determined by the number of lines
modified and the scope of the changes.

## Simple Changes (1–10 lines, obvious purpose)

```gitcommit
Add logging to user authentication flow

Track authentication attempts and failures to make
troubleshooting login issues easier.

Part-of: CMS-1234
```

## Medium Changes (10–100 lines, clear refactor/feature)

```gitcommit
Extract validation logic into separate module

Inline validation was repeated across three components,
making updates error-prone. A shared validator module
reduces duplication and adds unit test coverage.

Part-of: CMS-5678
```

## Complex Changes (100+ lines, architectural)

```gitcommit
Decouple asset search from data store selectors

Introduce a SearchProvider abstraction that allows
different search implementations, replacing the tight
coupling to Redux selectors.

The previous approach required mocking the entire Redux
store in tests. Search logic can now be tested
independently.

Part-of: CMS-9848
```

## Key Principle

More lines of code ≠ more lines of explanation. Lead with WHAT (intent), then WHY (motivation).
