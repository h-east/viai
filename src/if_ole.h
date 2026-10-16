// this ALWAYS GENERATED file contains the definitions for the interfaces


// File created by MIDL compiler version 3.01.75
// at Wed Jun 06 18:20:37 2001
// Compiler settings for .\if_ole.idl:
//  Os (OptLev=s), W1, Zp8, env=Win32, ms_ext, c_ext
//  error checks: none
//@@MIDL_FILE_HEADING(  )
#include "rpc.h"
#include "rpcndr.h"
#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif //COM_NO_WINDOWS_H

#ifndef __if_ole_h__
#define __if_ole_h__

#ifdef __cplusplus
extern "C"{
#endif

// Forward Declarations

#ifndef __IViAI_FWD_DEFINED__
#define __IViAI_FWD_DEFINED__
typedef interface IViAI IViAI;
#endif	// __IViAI_FWD_DEFINED__


#ifndef __ViAI_FWD_DEFINED__
#define __ViAI_FWD_DEFINED__

#ifdef __cplusplus
typedef class ViAI ViAI;
#else
typedef struct ViAI ViAI;
#endif // __cplusplus

#endif	// __ViAI_FWD_DEFINED__


// header files for imported files
#include "oaidl.h"

#ifndef __MIDL_user_allocate_free_DEFINED__
#define __MIDL_user_allocate_free_DEFINED__
    void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
    void __RPC_USER MIDL_user_free( void __RPC_FAR * );
#endif

#ifndef __IViAI_INTERFACE_DEFINED__
#define __IViAI_INTERFACE_DEFINED__

//***************************************
// Generated header for interface: IViAI
// at Wed Jun 06 18:20:37 2001
// using MIDL 3.01.75
//**************************************
// [oleautomation][dual][unique][helpstring][uuid][object]



EXTERN_C const IID IID_IViAI;

#if defined(__cplusplus) && !defined(CINTERFACE)

    interface DECLSPEC_UUID("BE8F954A-D4A0-4B15-832E-0EDFD51E73BB")
    IViAI : public IDispatch
    {
    public:
	virtual HRESULT STDMETHODCALLTYPE SendKeys(
	    /* [in] */ BSTR keys) = 0;

	virtual HRESULT STDMETHODCALLTYPE Eval(
	    /* [in] */ BSTR expr,
	    /* [retval][out] */ BSTR __RPC_FAR *result) = 0;

	virtual HRESULT STDMETHODCALLTYPE SetForeground( void) = 0;

	virtual HRESULT STDMETHODCALLTYPE GetHwnd(
	    /* [retval][out] */ UINT_PTR __RPC_FAR *result) = 0;

    };

#else	// C style interface

    typedef struct IViAIVtbl
    {
	BEGIN_INTERFACE

	HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )(
	    IViAI __RPC_FAR * This,
	    /* [in] */ REFIID riid,
	    /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);

	ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )(
	    IViAI __RPC_FAR * This);

	ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )(
	    IViAI __RPC_FAR * This);

	HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfoCount )(
	    IViAI __RPC_FAR * This,
	    /* [out] */ UINT __RPC_FAR *pctinfo);

	HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfo )(
	    IViAI __RPC_FAR * This,
	    /* [in] */ UINT iTInfo,
	    /* [in] */ LCID lcid,
	    /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo);

	HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetIDsOfNames )(
	    IViAI __RPC_FAR * This,
	    /* [in] */ REFIID riid,
	    /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,
	    /* [in] */ UINT cNames,
	    /* [in] */ LCID lcid,
	    /* [size_is][out] */ DISPID __RPC_FAR *rgDispId);

	/* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Invoke )(
	    IViAI __RPC_FAR * This,
	    /* [in] */ DISPID dispIdMember,
	    /* [in] */ REFIID riid,
	    /* [in] */ LCID lcid,
	    /* [in] */ WORD wFlags,
	    /* [out][in] */ DISPPARAMS __RPC_FAR *pDispParams,
	    /* [out] */ VARIANT __RPC_FAR *pVarResult,
	    /* [out] */ EXCEPINFO __RPC_FAR *pExcepInfo,
	    /* [out] */ UINT __RPC_FAR *puArgErr);

	HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SendKeys )(
	    IViAI __RPC_FAR * This,
	    /* [in] */ BSTR keys);

	HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Eval )(
	    IViAI __RPC_FAR * This,
	    /* [in] */ BSTR expr,
	    /* [retval][out] */ BSTR __RPC_FAR *result);

	HRESULT ( STDMETHODCALLTYPE __RPC_FAR *SetForeground )(
	    IViAI __RPC_FAR * This);

	HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetHwnd )(
	    IViAI __RPC_FAR * This,
	    /* [retval][out] */ UINT_PTR __RPC_FAR *result);

	END_INTERFACE
    } IViAIVtbl;

    interface IViAI
    {
	CONST_VTBL struct IViAIVtbl __RPC_FAR *lpVtbl;
    };

#ifdef COBJMACROS


#define IViAI_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IViAI_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IViAI_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IViAI_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define IViAI_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define IViAI_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define IViAI_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)


#define IViAI_SendKeys(This,keys)	\
    (This)->lpVtbl -> SendKeys(This,keys)

#define IViAI_Eval(This,expr,result)	\
    (This)->lpVtbl -> Eval(This,expr,result)

#define IViAI_SetForeground(This)	\
    (This)->lpVtbl -> SetForeground(This)

#define IViAI_GetHwnd(This,result)	\
    (This)->lpVtbl -> GetHwnd(This,result)

#endif // COBJMACROS


#endif	// C style interface



HRESULT STDMETHODCALLTYPE IViAI_SendKeys_Proxy(
    IViAI __RPC_FAR * This,
    /* [in] */ BSTR keys);


void __RPC_STUB IViAI_SendKeys_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IViAI_Eval_Proxy(
    IViAI __RPC_FAR * This,
    /* [in] */ BSTR expr,
    /* [retval][out] */ BSTR __RPC_FAR *result);


void __RPC_STUB IViAI_Eval_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IViAI_SetForeground_Proxy(
    IViAI __RPC_FAR * This);


void __RPC_STUB IViAI_SetForeground_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


HRESULT STDMETHODCALLTYPE IViAI_GetHwnd_Proxy(
    IViAI __RPC_FAR * This,
    /* [retval][out] */ UINT_PTR __RPC_FAR *result);


void __RPC_STUB IViAI_GetHwnd_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif	// __IViAI_INTERFACE_DEFINED__



#ifndef __ViAI_LIBRARY_DEFINED__
#define __ViAI_LIBRARY_DEFINED__

//***************************************
// Generated header for library: ViAI
// at Wed Jun 06 18:20:37 2001
// using MIDL 3.01.75
//**************************************
// [version][helpstring][uuid]



EXTERN_C const IID LIBID_ViAI;

#ifdef __cplusplus
EXTERN_C const CLSID CLSID_ViAI;

class DECLSPEC_UUID("0FC5FC34-0F74-4E54-9D57-E4E8621839B8")
ViAI;
#endif
#endif // __ViAI_LIBRARY_DEFINED__

// Additional Prototypes for ALL interfaces

unsigned long		  __RPC_USER  BSTR_UserSize(	 unsigned long __RPC_FAR *, unsigned long	     , BSTR __RPC_FAR * );
unsigned char __RPC_FAR * __RPC_USER  BSTR_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, BSTR __RPC_FAR * );
unsigned char __RPC_FAR * __RPC_USER  BSTR_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, BSTR __RPC_FAR * );
void			  __RPC_USER  BSTR_UserFree(	 unsigned long __RPC_FAR *, BSTR __RPC_FAR * );

// end of Additional Prototypes

#ifdef __cplusplus
}
#endif

#endif
