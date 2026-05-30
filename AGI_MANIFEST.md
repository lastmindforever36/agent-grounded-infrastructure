# AGI Manifest

AGI - Agent Grounded Infrastructure - is built around five constraints:

1. **Outcome over instruction pile**
   - The user states what good looks like.
   - The model chooses the efficient path from live evidence.

2. **Grounding over confidence**
   - Code, runtime, tests, logs, screenshots, DB state, and external docs beat
     memory and vibes.

3. **Small structural slices**
   - Work in issue-sized patches unless an active long-running goal explicitly
     spans many verified slices.

4. **Cutover discipline**
   - When a new path replaces an old one, the old path is deleted, redirected,
     demoted behind the new source of truth, or recorded as temporary
     compatibility with owner and removal criteria.

5. **Evidence before closure**
   - No checklist item, gate, or goal is complete without concrete proof.

This harness is intentionally opinionated but not rigid. It should expand the
model's search space, not narrow it into ceremony.

The public repo should be judged by whether a human or another AI can answer
four questions quickly:

1. What problem does this solve?
2. What gets installed?
3. Why does each component exist?
4. How do I prove it is safe before using it?
