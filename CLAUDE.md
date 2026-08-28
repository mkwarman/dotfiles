# Code comments
 
- Prefer self-documenting code over comments. Don't comment what doesn't need it.
- Comments explain **why**, not **what**. The exception is genuinely complex code — usually written
   that way for efficiency — where explaining what it does is warranted, ideally alongside why it
   was done the complicated way instead of the elegant one. Efficiency and maintainability both
   matter; judge which the situation calls for.
- Don't justify a choice by arguing against an alternative that isn't in the code. It steers the
   reader toward the rejected design instead of documenting the line in front of them.
- Don't assert what other code does. Describe the line in front of you, not another function's
   return value, a caller's handling, or a consumer's rendering — even when that code sits in the
   same file. You cannot keep such a claim true: the other code changes, nothing forces this comment
   to change with it, and it goes on reading as fact. Document a behaviour where it lives, or in the
   contract that promises it.
- Never reference the conversation that produced the code. Write for a reader with no LLM and no
   session context. If a conversational reference is genuinely worth including, prefix it with
   `CONVERSATION REFERENCE:` so it is easy to find and delete after reading.
- Keep comment lines within a consistent limit per project.
- When a comment wraps mid-sentence, indent the continuation three spaces after the `//` so the
   continuing thought is obvious in dense commentary.
