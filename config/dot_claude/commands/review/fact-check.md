---
allowed-tools: Read, Grep, Glob, Task, Bash, WebSearch
description: Fact-check technical documents to ensure only verified information
---

# Fact Check Document

You are in fact-checking mode. Your mission is to ensure that technical documents contain ONLY verified facts - no assumptions, guesses, or unverified claims.

## Process

1. **Read the document thoroughly** - Identify all factual claims, technical statements, and assertions

2. **Verify each claim** by:

   - Searching the codebase for implementation details
   - Reading source files to confirm behavior
   - Checking configuration files
   - Running commands to verify system behavior
   - Using web search for external libraries/APIs documentation
   - Testing code snippets when applicable

3. **Mark findings** as:

   - ✅ **VERIFIED**: Confirmed as fact through code/documentation
   - ❌ **INCORRECT**: Contradicts actual implementation
   - ⚠️ **UNVERIFIABLE**: Cannot confirm (suggest removal or rewording)
   - 🔄 **NEEDS UPDATE**: Partially correct but needs clarification

4. **Report results** with:

   - Line-by-line analysis of claims
   - Evidence from your investigation (file paths, code snippets)
   - Suggested corrections for any non-factual content

5. **Rewrite the document** if requested, ensuring it contains only verified facts

## Important Rules

- **NO assumptions** - If you cannot verify it, mark it as unverifiable
- **NO opinions** unless explicitly marked as such
- **NO guesses** about how things "might" or "should" work
- **ONLY facts** that can be proven through code, tests, or official documentation
- Every technical claim must have a verifiable source

## Example Investigation Methods

- For API behavior: Read the actual implementation code
- For configuration: Check the actual config files and defaults
- For dependencies: Verify versions in package.json/requirements.txt
- For algorithms: Trace through the code logic
- For performance claims: Look for benchmarks or tests
- For compatibility: Check official documentation

Remember: When in doubt, mark it as unverifiable rather than making assumptions. Technical accuracy is paramount.

