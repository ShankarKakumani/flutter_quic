# Phase 3 Prompts - Convenience API + Polish

## Overview
Phase 3 adds the Convenience API: QuicClient with Dio-style interface, connection pooling, and final polish.

**Building on**: Phase 2 (docs/dev/phase2_prompts.md)  
**Final Phase**: Project completion

---

## Task 3.1: Basic QuicClient Structure
```
"Create basic QuicClient convenience API structure

REFERENCE DOCUMENTS:
- Technical architecture: docs/core/technical_architecture.md (Convenience API)
- API checklist: docs/core/api_checklist.md (Convenience API methods)

BUILDING ON: Phase 2 (Complete Core API)

DELIVERABLES:
- Create rust/src/convenience/client.rs with QuicClient
- Built on top of Core API (use QuicEndpoint internally)
- Basic structure with configuration support
- Connection pooling foundation

PROGRESS TRACKING:
- Update TODO list: mark QuicClient structure as completed
- Verify: Uses Core API internally
- Verify: No duplicate Quinn integration

NEXT: Task 3.2 - Add send() method"
```

## Task 3.2: QuicClient.send() Method
```
"Implement QuicClient.send() method (Dio-style API)

REFERENCE DOCUMENTS:
- API checklist: docs/core/api_checklist.md (Convenience API methods)
- Error handling: docs/core/error_handling_strategy.md (wrapped errors)

BUILDING ON: Task 3.1 (QuicClient structure)

DELIVERABLES:
- Add send() method with URL and data parameters
- Connection pooling and reuse
- Automatic retry logic for transient errors
- Simple request/response pattern

PROGRESS TRACKING:
- Update docs/core/api_checklist.md: mark QuicClient.send() as completed
- Verify: Connection pooling works
- Verify: Retry logic handles timeouts

NEXT: Task 3.3 - Add get() and post() methods"
```

## Task 3.3: QuicClient HTTP-style Methods
```
"Implement QuicClient.get() and post() methods

REFERENCE DOCUMENTS:
- API checklist: docs/core/api_checklist.md (Convenience API methods)

BUILDING ON: Task 3.2 (QuicClient.send())

DELIVERABLES:
- Add get() method for simple requests
- Add post() method for data submission
- Built on send() method internally
- HTTP-like interface for Flutter developers

PROGRESS TRACKING:
- Update docs/core/api_checklist.md: mark get() and post() as completed
- Verify: Methods work as HTTP alternatives
- Verify: Consistent with Flutter HTTP patterns

NEXT: Task 3.4 - Final integration test"
```

## Task 3.4: Final Integration Test
```
"Create final integration test with complete Flutter QUIC package

REFERENCE DOCUMENTS:
- Implementation standards: docs/core/implementation_standards.md (testing requirements)
- API checklist: docs/core/api_checklist.md (verify all APIs)

BUILDING ON: Task 3.3 (QuicClient HTTP methods)

DELIVERABLES:
- End-to-end test with both Core and Convenience APIs
- Performance benchmarks vs HTTP/2
- Real-world usage examples
- Documentation and examples

PROGRESS TRACKING:
- Update docs/core/api_checklist.md: verify all APIs completed
- Verify: Package ready for production use
- Verify: Performance meets requirements
- Mark Phase 3 as COMPLETED
- Mark PROJECT as COMPLETED

NEXT: Package ready for release!"
```

---

## Phase 3 Summary

### Deliverables
- **QuicClient** with Dio-style interface
- **Connection pooling** with automatic management
- **HTTP-style methods** (get, post, send)
- **Automatic retry logic** for transient errors
- **Final integration test** with performance benchmarks
- **Complete package** ready for production

### Success Criteria
- Simple API handles 80% of use cases with minimal code
- Production-ready stability under load
- Clear performance advantages over HTTP in relevant scenarios
- Seamless integration with existing Flutter networking patterns

### Project Completion
After Phase 3, the Flutter QUIC package will be:
- **Feature complete** with Core and Convenience APIs
- **Production ready** with comprehensive testing
- **Performance optimized** within 5% of native Quinn
- **Well documented** with examples and usage patterns

---

**Status**: Phase 3 tasks defined  
**Outcome**: Complete Flutter QUIC package ready for release 