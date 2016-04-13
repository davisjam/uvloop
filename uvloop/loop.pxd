# cython: language_level=3


include "__debug.pxi" # Generated by "make"


from .includes cimport uv
from .includes cimport system

from libc.stdint cimport uint64_t, uint32_t, int64_t


include "includes/consts.pxi"


cdef extern from *:
     ctypedef int vint "volatile int"


cdef class UVHandle

cdef class UVAsync(UVHandle)
cdef class UVTimer(UVHandle)
cdef class UVSignal(UVHandle)
cdef class UVIdle(UVHandle)

ctypedef object (*method_t)(object)
ctypedef object (*method1_t)(object, object)
ctypedef object (*method2_t)(object, object, object)
ctypedef object (*method3_t)(object, object, object, object)
ctypedef object (*method4_t)(object, object, object, object, object)


cdef class Loop:
    cdef:
        uv.uv_loop_t *uvloop

        readonly bint _closed
        bint _debug
        bint _running
        bint _stopping

        long _thread_id
        bint _thread_is_main
        bint _sigint_check

        SignalsStack py_signals
        SignalsStack uv_signals
        bint _executing_py_code

        object _task_factory
        object _exception_handler
        object _default_executor
        object _ready
        Py_ssize_t _ready_len

        set _timers
        dict _polls
        dict _polls_gc

        dict _signal_handlers
        bint _custom_sigint

        UVAsync handler_async
        UVIdle handler_idle
        UVSignal handler_sigint
        UVSignal handler_sighup

        object _last_error

        cdef object __weakref__

        char _recv_buffer[UV_STREAM_RECV_BUF_SIZE]
        bint _recv_buffer_in_use

        IF DEBUG:
            readonly bint _debug_cc  # True when compiled with DEBUG.
                                     # Only for unittests.

            readonly object _debug_handles_total
            readonly object _debug_handles_closed
            readonly object _debug_handles_current

            readonly uint64_t _debug_cb_handles_total
            readonly uint64_t _debug_cb_handles_count
            readonly uint64_t _debug_cb_timer_handles_total
            readonly uint64_t _debug_cb_timer_handles_count

            readonly uint64_t _debug_stream_shutdown_errors_total
            readonly uint64_t _debug_stream_listen_errors_total

            readonly uint64_t _debug_stream_read_cb_total
            readonly uint64_t _debug_stream_read_cb_errors_total
            readonly uint64_t _debug_stream_read_eof_total
            readonly uint64_t _debug_stream_read_eof_cb_errors_total
            readonly uint64_t _debug_stream_read_errors_total

            readonly uint64_t _debug_stream_write_errors_total
            readonly uint64_t _debug_stream_write_ctx_total
            readonly uint64_t _debug_stream_write_ctx_cnt
            readonly uint64_t _debug_stream_write_cb_errors_total

            readonly uint64_t _poll_read_events_total
            readonly uint64_t _poll_read_cb_errors_total
            readonly uint64_t _poll_write_events_total
            readonly uint64_t _poll_write_cb_errors_total

            readonly uint64_t _sock_try_read_total
            readonly uint64_t _sock_try_write_total

            readonly uint64_t _debug_exception_handler_cnt

    cdef _on_wake(self)
    cdef _on_idle(self)
    cdef _on_sigint(self)
    cdef _on_sighup(self)

    cdef _check_sigint(self)

    cdef __run(self, uv.uv_run_mode)
    cdef _run(self, uv.uv_run_mode)

    cdef _close(self)
    cdef _stop(self, exc)
    cdef uint64_t _time(self)

    cdef _call_soon(self, object callback, object args)
    cdef _call_soon_handle(self, Handle handle)

    cdef _call_later(self, uint64_t delay, object callback, object args)

    cdef void _handle_exception(self, object ex)

    cdef inline _check_signal(self, sig)
    cdef inline _check_closed(self)
    cdef inline _check_thread(self)

    cdef _getaddrinfo(self, str host, int port,
                      int family, int type,
                      int proto, int flags,
                      int unpack)

    cdef _getnameinfo(self, system.sockaddr *addr, int flags)

    cdef _add_reader(self, fd, Handle handle)
    cdef _remove_reader(self, fd)

    cdef _add_writer(self, fd, Handle handle)
    cdef _remove_writer(self, fd)

    cdef _sock_recv(self, fut, int registered, sock, n)
    cdef _sock_sendall(self, fut, int registered, sock, data)
    cdef _sock_accept(self, fut, int registered, sock)

    cdef _sock_connect(self, fut, sock, address)
    cdef _sock_connect_cb(self, fut, sock, address)

    cdef _connect_tcp_transport(self, UVTCPTransport transport,
                                system.sockaddr* addr)

    cdef _connect_unix_transport(self, UVPipeTransport transport,
                                 bytes addr)

include "cbhandles.pxd"

include "handles/handle.pxd"
include "handles/async_.pxd"
include "handles/idle.pxd"
include "handles/timer.pxd"
include "handles/signal.pxd"
include "handles/poll.pxd"
include "handles/stream.pxd"
include "handles/transport.pxd"
include "handles/tcp.pxd"
include "handles/pipe.pxd"
include "handles/process.pxd"

include "request.pxd"

include "server.pxd"

include "os_signal.pxd"
