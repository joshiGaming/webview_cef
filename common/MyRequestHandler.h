#include "include/cef_life_span_handler.h"

class MyLifeSpanHandler : public CefLifeSpanHandler {
public:
    MyLifeSpanHandler() {}
    ~MyLifeSpanHandler() {}


      virtual bool OnBeforePopup(CefRefPtr<CefBrowser> browser,
                             CefRefPtr<CefFrame> frame,
                             const CefString& target_url,
                             const CefString& target_frame_name,
                             WindowOpenDisposition target_disposition,
                             bool user_gesture,
                             const CefPopupFeatures& popupFeatures,
                             CefWindowInfo& windowInfo,
                             CefRefPtr<CefClient>& client,
                             CefBrowserSettings& settings,
                             CefRefPtr<CefDictionaryValue>& extra_info,
                             bool* no_javascript_access) override {
        // Prevent the popup from being created
        return false;
    }
      virtual void OnAfterCreated(CefRefPtr<CefBrowser> browser) override  {}


  virtual bool DoClose(CefRefPtr<CefBrowser> browser) override  { return false; }

  virtual void OnBeforeClose(CefRefPtr<CefBrowser> browser) override  {}

    void AddRef() const override {
        // Implement the AddRef method here if necessary.
        // By default, this method does nothing.
    }

    bool Release() const override {
        // Implement the Release method here if necessary.
        // By default, this method returns true if the reference count drops to zero,
        // and false otherwise.
        return true;
    }

    bool HasOneRef() const override {
        // Return true if this object has only one reference, false otherwise.
        // By default, this method returns true.
        // If you override this method, you must ensure that it always returns true
        // or false consistently with the implementation of CefRefPtr.
        return true;
    }

    bool HasAtLeastOneRef() const override {
        // Return true if this object has at least one reference, false otherwise.
        // By default, this method returns true.
        // If you override this method, you must ensure that it always returns true
        // or false consistently with the implementation of CefRefPtr.
        return true;
    }

};