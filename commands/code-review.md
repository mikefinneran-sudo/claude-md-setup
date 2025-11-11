# Code Review Command

Perform a thorough code review of the specified file or component.

## Task

Review code: {{ARG_1}}

## Instructions

1. **Initial Analysis**:
   - Read the entire file/component
   - Understand its purpose and context
   - Identify key functionality
   - Note dependencies and relationships

2. **Review Checklist**:

   ### Correctness
   - [ ] Logic is sound
   - [ ] Edge cases are handled
   - [ ] No off-by-one errors
   - [ ] Correct algorithm implementation

   ### Code Quality
   - [ ] Clear and descriptive names
   - [ ] Appropriate abstraction levels
   - [ ] DRY (Don't Repeat Yourself)
   - [ ] SOLID principles followed
   - [ ] Proper separation of concerns

   ### Error Handling
   - [ ] All errors caught appropriately
   - [ ] Meaningful error messages
   - [ ] Proper error propagation
   - [ ] No swallowed exceptions

   ### Testing
   - [ ] Unit tests exist
   - [ ] Edge cases tested
   - [ ] Error cases tested
   - [ ] Good test coverage

   ### Security
   - [ ] No SQL injection risks
   - [ ] No XSS vulnerabilities
   - [ ] Input validation present
   - [ ] Authentication/authorization correct
   - [ ] No sensitive data exposure

   ### Performance
   - [ ] No unnecessary loops
   - [ ] Efficient data structures used
   - [ ] No N+1 queries
   - [ ] Appropriate caching

   ### Readability
   - [ ] Clear comments where needed
   - [ ] Self-documenting code
   - [ ] Consistent style
   - [ ] Logical organization

   ### Maintainability
   - [ ] Easy to modify
   - [ ] Well-documented
   - [ ] Clear dependencies
   - [ ] No technical debt

3. **Review Output**:

   ## Summary
   - Overall quality assessment
   - Main strengths
   - Main concerns

   ## Critical Issues
   List any bugs, security issues, or major problems:
   - **File:Line** - Description and fix

   ## Suggestions
   Improvements and optimizations:
   - **File:Line** - Suggestion with rationale

   ## Questions
   Areas needing clarification:
   - Question about specific implementation choices

   ## Positive Feedback
   Things done well worth highlighting

4. **Code Examples**:
   - For issues, show problematic code
   - Provide specific fix suggestions
   - Include before/after examples

## Style

- Be constructive and specific
- Reference exact line numbers
- Explain the "why" behind suggestions
- Prioritize: Critical → Important → Nice-to-have
- Acknowledge good practices
- Professional and respectful tone
