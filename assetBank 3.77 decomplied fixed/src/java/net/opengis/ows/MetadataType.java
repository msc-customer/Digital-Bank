/*     */ package net.opengis.ows;
/*     */ 
/*     */ import javax.xml.bind.annotation.XmlAccessType;
/*     */ import javax.xml.bind.annotation.XmlAccessorType;
/*     */ import javax.xml.bind.annotation.XmlAttribute;
/*     */ import javax.xml.bind.annotation.XmlElement;
/*     */ import javax.xml.bind.annotation.XmlSchemaType;
/*     */ import javax.xml.bind.annotation.XmlType;
/*     */ 
/*     */ @XmlAccessorType(XmlAccessType.FIELD)
/*     */ @XmlType(name="MetadataType", propOrder={"abstractMetaData"})
/*     */ public class MetadataType
/*     */ {
/*     */ 
/*     */   @XmlElement(name="AbstractMetaData")
/*     */   protected Object abstractMetaData;
/*     */ 
/*     */   @XmlAttribute(name="about")
/*     */   @XmlSchemaType(name="anyURI")
/*     */   protected String about;
/*     */ 
/*     */   @XmlAttribute(name="type", namespace="http://www.w3.org/1999/xlink")
/*     */   protected String type;
/*     */ 
/*     */   @XmlAttribute(name="href", namespace="http://www.w3.org/1999/xlink")
/*     */   @XmlSchemaType(name="anyURI")
/*     */   protected String href;
/*     */ 
/*     */   @XmlAttribute(name="role", namespace="http://www.w3.org/1999/xlink")
/*     */   @XmlSchemaType(name="anyURI")
/*     */   protected String role;
/*     */ 
/*     */   @XmlAttribute(name="arcrole", namespace="http://www.w3.org/1999/xlink")
/*     */   @XmlSchemaType(name="anyURI")
/*     */   protected String arcrole;
/*     */ 
/*     */   @XmlAttribute(name="title", namespace="http://www.w3.org/1999/xlink")
/*     */   protected String title;
/*     */ 
/*     */   @XmlAttribute(name="show", namespace="http://www.w3.org/1999/xlink")
/*     */   protected String show;
/*     */ 
/*     */   @XmlAttribute(name="actuate", namespace="http://www.w3.org/1999/xlink")
/*     */   protected String actuate;
/*     */ 
/*     */   public Object getAbstractMetaData()
/*     */   {
/*  80 */     return this.abstractMetaData;
/*     */   }
/*     */ 
/*     */   public void setAbstractMetaData(Object value)
/*     */   {
/*  92 */     this.abstractMetaData = value;
/*     */   }
/*     */ 
/*     */   public String getAbout()
/*     */   {
/* 104 */     return this.about;
/*     */   }
/*     */ 
/*     */   public void setAbout(String value)
/*     */   {
/* 116 */     this.about = value;
/*     */   }
/*     */ 
/*     */   public String getType()
/*     */   {
/* 128 */     if (this.type == null) {
/* 129 */       return "simple";
/*     */     }
/* 131 */     return this.type;
/*     */   }
/*     */ 
/*     */   public void setType(String value)
/*     */   {
/* 144 */     this.type = value;
/*     */   }
/*     */ 
/*     */   public String getHref()
/*     */   {
/* 156 */     return this.href;
/*     */   }
/*     */ 
/*     */   public void setHref(String value)
/*     */   {
/* 168 */     this.href = value;
/*     */   }
/*     */ 
/*     */   public String getRole()
/*     */   {
/* 180 */     return this.role;
/*     */   }
/*     */ 
/*     */   public void setRole(String value)
/*     */   {
/* 192 */     this.role = value;
/*     */   }
/*     */ 
/*     */   public String getArcrole()
/*     */   {
/* 204 */     return this.arcrole;
/*     */   }
/*     */ 
/*     */   public void setArcrole(String value)
/*     */   {
/* 216 */     this.arcrole = value;
/*     */   }
/*     */ 
/*     */   public String getTitle()
/*     */   {
/* 228 */     return this.title;
/*     */   }
/*     */ 
/*     */   public void setTitle(String value)
/*     */   {
/* 240 */     this.title = value;
/*     */   }
/*     */ 
/*     */   public String getShow()
/*     */   {
/* 252 */     return this.show;
/*     */   }
/*     */ 
/*     */   public void setShow(String value)
/*     */   {
/* 264 */     this.show = value;
/*     */   }
/*     */ 
/*     */   public String getActuate()
/*     */   {
/* 276 */     return this.actuate;
/*     */   }
/*     */ 
/*     */   public void setActuate(String value)
/*     */   {
/* 288 */     this.actuate = value;
/*     */   }
/*     */ }

/* Location:           D:\Project - Photint Asset-bank\net\opengis\ows.zip
 * Qualified Name:     ows.MetadataType
 * JD-Core Version:    0.6.0
 */