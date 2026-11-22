package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestRoutes(t *testing.T) {
	tests := []struct {
		method string
		path   string
		code   int
		body   string
	}{
		{http.MethodGet, "/health", http.StatusOK, "{\"status\":\"ok\"}\n"},
		{http.MethodGet, "/", http.StatusOK, "hello from dev"},
		{http.MethodGet, "/missing", http.StatusNotFound, ""},
		{http.MethodPost, "/", http.StatusMethodNotAllowed, ""},
	}

	h := newMux("hello from dev")

	for _, tt := range tests {
		t.Run(tt.method+" "+tt.path, func(t *testing.T) {
			rec := httptest.NewRecorder()
			h.ServeHTTP(rec, httptest.NewRequest(tt.method, tt.path, nil))

			if rec.Code != tt.code {
				t.Fatalf("status: got %d, want %d", rec.Code, tt.code)
			}
			if tt.body != "" && rec.Body.String() != tt.body {
				t.Errorf("body: got %q, want %q", rec.Body.String(), tt.body)
			}
		})
	}
}
