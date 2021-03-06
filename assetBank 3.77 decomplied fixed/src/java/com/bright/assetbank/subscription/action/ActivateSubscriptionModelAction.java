/*    */ package com.bright.assetbank.subscription.action;
/*    */ 
/*    */ import com.bn2web.common.exception.Bn2Exception;
/*    */ import com.bright.assetbank.subscription.constant.SubscriptionConstants;
/*    */ import com.bright.assetbank.subscription.service.SubscriptionManager;
/*    */ import com.bright.assetbank.user.bean.ABUserProfile;
/*    */ import com.bright.framework.common.action.BTransactionAction;
/*    */ import com.bright.framework.database.bean.DBTransaction;
/*    */ import com.bright.framework.user.bean.UserProfile;
/*    */ import javax.servlet.http.HttpServletRequest;
/*    */ import javax.servlet.http.HttpServletResponse;
/*    */ import org.apache.commons.logging.Log;
/*    */ import org.apache.struts.action.ActionForm;
/*    */ import org.apache.struts.action.ActionForward;
/*    */ import org.apache.struts.action.ActionMapping;
/*    */ 
/*    */ public class ActivateSubscriptionModelAction extends BTransactionAction
/*    */   implements SubscriptionConstants
/*    */ {
/* 43 */   private SubscriptionManager m_subscriptionManager = null;
/*    */ 
/*    */   public void setSubscriptionManager(SubscriptionManager a_subscriptionManager) {
/* 46 */     this.m_subscriptionManager = a_subscriptionManager;
/*    */   }
/*    */ 
/*    */   public ActionForward execute(ActionMapping a_mapping, ActionForm a_form, HttpServletRequest a_request, HttpServletResponse a_response, DBTransaction a_dbTransaction)
/*    */     throws Bn2Exception
/*    */   {
/* 69 */     ActionForward afForward = null;
/* 70 */     ABUserProfile userProfile = (ABUserProfile)UserProfile.getUserProfile(a_request.getSession());
/*    */ 
/* 73 */     if (!userProfile.getIsAdmin())
/*    */     {
/* 75 */       this.m_logger.debug("This user does not have permission to view the admin pages");
/* 76 */       return a_mapping.findForward("NoPermission");
/*    */     }
/*    */ 
/* 79 */     long lId = getLongParameter(a_request, "id");
/*    */ 
/* 81 */     String sActive = a_request.getParameter("active");
/* 82 */     boolean bActive = sActive.compareToIgnoreCase("true") == 0;
/*    */ 
/* 84 */     this.m_subscriptionManager.activateSubscriptionModel(a_dbTransaction, lId, bActive);
/*    */ 
/* 87 */     String sQueryString = "";
/* 88 */     afForward = createRedirectingForward(sQueryString, a_mapping, "Success");
/*    */ 
/* 90 */     return afForward;
/*    */   }
/*    */ }

/* Location:           C:\Users\mamatha\Desktop\com.zip
 * Qualified Name:     com.bright.assetbank.subscription.action.ActivateSubscriptionModelAction
 * JD-Core Version:    0.6.0
 */